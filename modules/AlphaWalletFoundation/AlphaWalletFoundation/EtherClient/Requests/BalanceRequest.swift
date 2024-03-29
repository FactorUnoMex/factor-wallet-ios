// Copyright SIX DAY LLC. All rights reserved.

import BigInt
import Foundation
import JSONRPCKit

struct BalanceRequest: JSONRPCKit.Request {
    typealias Response = Balance

    let address: AlphaWallet.Address

    var method: String {
        return "eth_getBalance"
    }

    var parameters: Any? {
        return [address.eip55String, "latest"]
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String, let value = BigUInt(response.drop0x, radix: 16) {
            return Balance(value: value)
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
