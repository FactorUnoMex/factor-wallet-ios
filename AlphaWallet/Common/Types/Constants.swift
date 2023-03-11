//
//  Constants.swift
//  AlphaWallet
//
//  Created by Vladyslav Shepitko on 14.09.2022.
//

import Foundation
import AlphaWalletFoundation

extension Constants {
    //Misc
    static let etherReceivedNotificationIdentifier = "etherReceivedNotificationIdentifier"

    static let keychainKeyPrefix = "factorwallet"
    static let xdaiDropPrefix = Data([0x58, 0x44, 0x41, 0x49, 0x44, 0x52, 0x4F, 0x50]).hex()

    enum WalletConnect {
        static let server = "FactorWallet"
        static let websiteUrl = URL(string: Constants.website)!
        static let icons = [
            "https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media"
        ]
        static let connectionTimeout: TimeInterval = 10
    }

    static let launchShortcutKey = "net.factor-wallet.alphawallet.qrScanner"

    // social
    static let website = "https://factor-wallet.net/"
    static let twitterUsername = "FactorNews_"
    static let redditGroupName = "r/FactorWallet/"
    static let facebookUsername = "FactorNews1"

    // support
    static let supportEmail = "feedback+ios@factor-wallet.net"

    static let dappsBrowserURL = URL(string: "http://aw.app")!
}
