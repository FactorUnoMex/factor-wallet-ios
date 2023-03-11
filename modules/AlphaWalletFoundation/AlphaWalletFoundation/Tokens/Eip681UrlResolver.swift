// Copyright © 2018 Stormbird PTE. LTD.

import Foundation
import BigInt
import PromiseKit
import Combine

// TODO: prepare tests for Eip681UrlResolver
public final class Eip681UrlResolver {
    public enum Resolution {
        case address(AlphaWallet.Address)
        case transaction(TransactionType, token: Token)
    }

    public enum MissingRpcServerStrategy {
        case fallbackToFirstMatching
        case fallbackToAnyMatching
        case fallbackToPreffered(RPCServer)
    }

    private let config: Config
    private let importToken: ImportToken
    private let missingRPCServerStrategy: MissingRpcServerStrategy

    public init(config: Config, importToken: ImportToken, missingRPCServerStrategy: MissingRpcServerStrategy) {
        self.importToken = importToken
        self.config = config
        self.missingRPCServerStrategy = missingRPCServerStrategy
    }

    @discardableResult public func resolve(url: URL) -> AnyPublisher<Eip681UrlResolver.Resolution, CheckEIP681Error> {
        switch AddressOrEip681Parser.from(string: url.absoluteString) {
        case .address(let address):
            return .just(.address(address))
        case .eip681(let protocolName, let address, let functionName, let params):
            return resolve(protocolName: protocolName, address: address, functionName: functionName, params: params)
        case .none:
            return .fail(CheckEIP681Error.notEIP681)
        }
    }

    @discardableResult public func resolve(protocolName: String, address: AddressOrEnsName, functionName: String?, params: [String: String]) -> AnyPublisher<Eip681UrlResolver.Resolution, CheckEIP681Error> {
        return Just(protocolName)
            .setFailureType(to: CheckEIP681Error.self)
            .map { protocolName in
                Eip681Parser(protocolName: protocolName, address: address, functionName: functionName, params: params).parse()
            }.flatMap { [importToken] result -> AnyPublisher<Eip681UrlResolver.Resolution, CheckEIP681Error> in
                guard let (contract: contract, customServer, recipient, amount) = result.parameters else {
                    return .fail(CheckEIP681Error.parameterInvalid)
                }
                guard let server = self.serverFromEip681LinkOrDefault(customServer) else {
                    return .fail(CheckEIP681Error.missingRpcServer)
                }

                return importToken
                    .importTokenPublisher(for: contract, server: server)
                    .mapError { CheckEIP681Error.embeded(error: $0) }
                    .flatMap { token -> AnyPublisher<Eip681UrlResolver.Resolution, CheckEIP681Error> in
                        switch token.type {
                        case .erc20, .nativeCryptocurrency:
                            let transactionType = Eip681UrlResolver.buildFungibleTransactionType(token, recipient: recipient, amount: amount)
                            return .just(.transaction(transactionType, token: token))
                        case .erc1155, .erc721, .erc721ForTickets, .erc875:
                            return .fail(CheckEIP681Error.tokenTypeNotSupported)
                        }
                    }.eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }

    private func serverFromEip681LinkOrDefault(_ serverInLink: RPCServer?) -> RPCServer? {
        if let server = serverInLink {
            return server
        } else {
            switch missingRPCServerStrategy {
            case .fallbackToAnyMatching:
                return serverInLink ?? config.anyEnabledServer()
            case .fallbackToFirstMatching:
                //Specs https://eips.ethereum.org/EIPS/eip-681 says we should fallback to the current chainId, but since we support multiple chains at the same time, we only fallback if there is exactly 1 enabled network
                return config.enabledServers.count == 1 ? config.enabledServers[0] : nil
            case .fallbackToPreffered(let server):
                return server
            }
        }
    }

    private static func buildFungibleTransactionType(_ token: Token, recipient: AddressOrEnsName?, amount amount: Eip681Amount) -> TransactionType {
        let amountToSend: FungibleAmount

        //NOTE: use decimals only if send ether or number has e notation
        var decimals: Int = 0
        switch amount {
        case .ether(let value):
            decimals = token.decimals
        case .uint256(let value, let eNotation):
            if eNotation { //If a number has e notation, we treat as number need to be converted as
                decimals = token.decimals
            } else {
                decimals = 0
            }
        }

        if let amount = amount.rawValue.scientificAmountToBigInt, let value = Decimal(bigUInt: BigUInt(amount), decimals: decimals) {
            amountToSend = .amount(value.doubleValue)
        } else if let amount = DecimalParser().parseAnyDecimal(from: amount.rawValue) {
            amountToSend = .amount(amount.doubleValue)
        } else {
            amountToSend = .notSet
        }
        return TransactionType(fungibleToken: token, recipient: recipient, amount: amountToSend)
    }
}

extension Decimal {

    public var decimalCount: Int {
        max(-exponent, 0)
    }

    public init?(bigInt: BigInt, decimals: Int) {
        guard let significand = Decimal(string: bigInt.description, locale: .en_US) else {
            return nil
        }
        let sign: FloatingPointSign
        switch bigInt.sign {
        case .minus:
            sign = .minus
        case .plus:
            sign = .plus
        }
        self.init(sign: sign, exponent: -decimals, significand: significand)
    }

    public init?(bigUInt: BigUInt, decimals: Int) {
        guard let significand = Decimal(string: bigUInt.description, locale: .en_US) else {
            return nil
        }
        self.init(sign: .plus, exponent: -decimals, significand: significand)
    }

    public init(double: Double) {
        self.init(string: String(double), locale: .en_US)!
    }

}

//NOTE: Maybe it could be better to use Decimal instead of Double, but we can't use it because
// - check for ((Decimal(0.001) / Decimal(0.02231)) * Decimal(0.02231) == Decimal(0.001)) returns false
// - in some places we need to use Double and when we call .doubleValue for Decimal number it actually return not that value we expect, 1.0000000000000002e-06 when 1e-06 expected
extension Decimal {

    func roundedString(decimal: Int) -> String {
        let poweredDecimal = self * pow(10, decimal)
        let handler = NSDecimalNumberHandler(roundingMode: .plain, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let roundedDecimal = NSDecimalNumber(decimal: poweredDecimal).rounding(accordingToBehavior: handler).decimalValue

        return String(describing: roundedDecimal)
    }

    public func toBigInt(decimals: Int) -> BigInt? {
        return BigInt(roundedString(decimal: decimals))
    }

}

public class DecimalParser {

    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false

        return formatter
    }()

    public init() { }

    public func parseAnyDecimal(from string: String?) -> Decimal? {
        if let string = string {
            for localeIdentifier in Locale.availableIdentifiers {
                formatter.locale = Locale(identifier: localeIdentifier)
                if formatter.number(from: "0\(string)") == nil {
                    continue
                }

                let string = string.replacingOccurrences(of: formatter.decimalSeparator, with: ".")
                if let decimal = Decimal(string: string, locale: .en_US) {
                    return decimal
                }
             }
         }
        return nil
    }

}