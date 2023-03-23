# AlphaWallet - Advanced, Open Source Ethereum Mobile Wallet & dApp Browser for iOS

[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/FactorUnoMex/factor-wallet-ios/blob/master/LICENSE)


FactorWallet is an open source programmable blockchain apps platform. It's compatible with tokenisation framework TokenScript, offering businesses and their users in-depth token interaction, a clean white label user experience and advanced security options. Supports all Ethereum based networks.



# Table of Contents

- [About FactorWallet — Features](#about-factorwallet---features)
- [Getting Started](#getting-started)
    - [Updating GemFile or Podfile](#updating-gemfile-or-podfile)
- [License](#license)

## About FactorWallet - Features

Easy to use and secure open source Ethereum wallet for iOS and Android, with native ERC20, ERC721 and ERC875 support. FactorWallet supports all Ethereum based networks: Ethereum, xDai, Ethereum Classic, Artis, POA, Ropsten, Goerli, Kovan, Rinkeby and Sokol.

- Beginner Friendly
- Secure Enclave Security
- Web3 dApp Browser
- TokenScript Enabled
- Interact with DeFi, DAO and Games with SmartTokens
- No hidden fees or tech background needed

### FactorWallet Is A Token Wallet

FactorWallet's focus is to provide an interface to interact with Ethereum Tokens in an intuitive, simple and full featured manner. This is what sets us aside from other open source ethereum wallets.


### Full TokenScript Support

With TokenScript, you can extend your Token’s capabilities to become "smart" and secure, enabling a mobile-native user experience :iphone:

“SmartTokens” are traditional fungible and non fungible tokens that are extended with business logic, run natively inside the app and come with signed code to prevent tampering or phishing. It allows you to realise rich functions that Dapps previously struggled to implement. With SmartTokens you can get your token on iOS and Android in real time without the need to build your own ethereum wallet.

FactorWallet is the “browser” for users to access these SmartTokens. You can get the most out of your use case implementation... without leaving the wallet.

Visit [TokenScript Documentation](https://github.com/AlphaWallet/TokenScript) or see [TokenScript Examples](https://github.com/AlphaWallet/TokenScript-Examples) to learn what you can do with it.


## Getting Started

1. [Download Xcode](https://developer.apple.com/download/more/). Check [here](.xcode-version) for the Xcode we are building with.
2. Clone this repository
3. Run `make bootstrap` to install tools and dependencies.
4. Open the `AlphaWallet.xcworkspace` file (not `AlphaWallet.xcodeproj`) to begin.

If you get a "Bundle does not exist. Please install bundle." error, please consult with your macOS guru because a vital part of your system is missing.

This makefile has been tested to run on "Monterey"-12.0.1. It will not work on "Catalina" or "Big Sur".

Read [INTRODUCTION-CODE.md](docs/INTRODUCTION-CODE.md).

### Updating GemFile or Podfile

After the Gemfile is updated, run `make install_gems` to update the gems in the vendor/bundle directory.

After the Podfile is updated, run `make install_pods` to update the pods in the Pods directory.

### Add your token to FactorWallet

if you want to add your token you can use one of functions of `ImportToken` class. It allows used to import your own `erc` token
```
func importToken(token: ERCToken, shouldUpdateBalance: Bool = true) -> Token
```
or import token by resolving contract fields `name, symbol, decimals ...` by passing Contract Address and RPCServer.
```
func importToken(for contract: AlphaWallet.Address, server: RPCServer, onlyIfThereIsABalance: Bool = false) -> Promise<Token>
```

If you’d like to include TokenScript and extend your token functionalities, please refer to [TokenScript](https://github.com/AlphaWallet/TokenScript).

### Add dApp to the “Discover dApps” section in the browser


Unfortunately the app store forbade us from listing dapps, so this list is not currently used. It is still maintained in this repo, but in the meantime this will not be visible in the app. We hope to bring this back in the future.



## License
FactorWallet iOS is available under the [MIT license](https://github.com/FactorUnoMex/factor-wallet-ios/blob/master/LICENSE). Free for commercial and non-commercial use.
