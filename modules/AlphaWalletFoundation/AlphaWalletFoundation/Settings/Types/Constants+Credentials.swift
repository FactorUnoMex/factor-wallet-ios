// Copyright © 2019 Stormbird PTE. LTD.
import Foundation
import AlphaWalletLogger

extension Constants {
    public enum Credentials {
        private static var cachedDevelopmentCredentials: [String: String]? = readDevelopmentCredentialsFile()

        private static func readDevelopmentCredentialsFile() -> [String: String]? {
            guard let sourceRoot = ProcessInfo.processInfo.environment["SOURCE_ROOT"] else {
                debugLog("[Credentials] No .credentials file found for development because SOURCE_ROOT is not set")
                return nil
            }
            let fileName = "\(sourceRoot)/.credentials"
            guard let fileContents = try? String(contentsOfFile: fileName) else {
                debugLog("[Credentials] No .credentials file found for development at \(fileName)")
                return nil
            }
            let lines = fileContents.components(separatedBy: .newlines)
            let keyValues: [(String, String)] = lines.compactMap { line -> (String, String)? in
                Constants.Credentials.functional.extractKeyValueCredentials(line)
            }
            let dict = Dictionary(uniqueKeysWithValues: keyValues)
            debugLog("[Credentials] Loaded .credentials file found for development with key count: \(dict.count)")
            return dict
        }

        private static func env(_ name: String) -> String? {
            if Environment.isDebug, let cachedDevelopmentCredentials = cachedDevelopmentCredentials {
                return cachedDevelopmentCredentials[name]
            } else {
                //We inject the environment variables into the app through Xcode scheme configuration (we do this so that we can pass the environment variables injected by Travis dashboard into the shell to the app). But this means the injected/forwarded variables will be an empty string if they are missing (and no longer nil)
                if let value = ProcessInfo.processInfo.environment[name], !value.isEmpty {
                    return value
                } else {
                    return nil
                }
            }
        }

        public static let analyticsKey = ""
        public static let mailChimpListSpecificKey = ""
        public static let walletConnectProjectId = env("WALLETCONNECTPROJECTID") ?? "AIzaSyBm6VhZbvhLbxfCsYBKh3LMk2I0Iz1-S-M"
        static let infuraKey = env("INFURAKEY") ?? "AIzaSyDcfnRlk0N_RBa26SJFt8hdUBV87VnyJNc"
        static let etherscanKey = env("ETHERSCANKEY") ?? "AIzaSyBDr37NIRMCeMLmfHvyVJPThI35GAXOh00"
        static let binanceSmartChainExplorerApiKey: String? = env("BINANCESMARTCHAINEXPLORERAPIKEY") ?? "AIzaSyDVn11k2cdXVMNnAdeGkOCMGtp-FqFah3Q"
        static let polygonScanExplorerApiKey: String? = env("POLYGONSCANEXPLORERAPIKEY") ?? "AIzaSyBdB7gLwJzKQQ-MGp3atM0Q-VvNQjkWpuU"
        static let paperTrail = (host: env("PAPERTRAILHOST") ?? "", port: (env("PAPERTRAILPORT") ?? "").toInt() ?? 0)
        static let openseaKey = env("OPENSEAKEY") ?? nil
        static let rampApiKey = env("RAMPAPIKEY") ?? "AIzaSyDbsBb0AfN9uDDjP5W3tEpGTpUKfAIqI0Q"
        static let coinbaseAppId = env("COINBASEAPPID") ?? ""
        static let enjinUserName = env("ENJINUSERNAME") ?? ""
        static let enjinUserPassword = env("ENJINUSERPASSWORD") ?? ""
        static let unstoppableDomainsV2ApiKey = env("UNSTOPPABLEDOMAINSV2KEY") ?? ""
        static let blockscanChatProxyKey = env("BLOCKSCHATPROXYKEY") ?? ""
        static let covalentApiKey = env("COVALENTAPIKEY") ?? ""
        //Without the "Basic " prefix
        static let klaytnRpcNodeKeyBasicAuth = env("KLAYTNRPCNODEKEYBASICAUTH") ?? ""
    }
}

extension Constants.Credentials {
    public enum functional {}
}

extension Constants.Credentials.functional {
    public static func extractKeyValueCredentials(_ line: String) -> (key: String, value: String)? {
        let keyValue = line.components(separatedBy: "=")
        if keyValue.count == 2 {
            return (keyValue[0], keyValue[1])
        } else if keyValue.count > 2 {
            //Needed to handle when = is in the API value, example Basic Auth
            return (keyValue[0], keyValue[1..<keyValue.count].joined(separator: "="))
        } else {
            return nil
        }
    }
}
