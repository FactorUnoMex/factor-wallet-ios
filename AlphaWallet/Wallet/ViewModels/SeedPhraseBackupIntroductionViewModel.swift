// Copyright © 2019 Stormbird PTE. LTD.

import Foundation
import UIKit
import AlphaWalletFoundation

struct SeedPhraseBackupIntroductionViewModel {

    var title: String {
        return R.string.localizable.walletsBackupHdWalletIntroductionButtonTitle()
    } 

    var imageViewImage: UIImage {
        return R.image.hdIntroduction()!
    }
    
    var attributedSubtitle: NSAttributedString {
        let subtitle = R.string.localizable.walletsBackupHdWalletIntroductionTitle()
        let attributeString = NSMutableAttributedString(string: subtitle)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineSpacing = ScreenChecker.size(big: 18, medium: 14, small: 7)

        attributeString.addAttributes([
            .paragraphStyle: style,
            .font: Screen.Backup.subtitleFont,
            .foregroundColor: Configuration.Color.Semantic.defaultForegroundText
        ], range: NSRange(location: 0, length: subtitle.count))
        
        return attributeString
    }
    
    var attributedDescription: NSAttributedString {
        let description = R.string.localizable.walletsShowSeedPhraseSubtitle()
        let attributeString = NSMutableAttributedString(string: description)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineSpacing = ScreenChecker.size(big: 18, medium: 14, small: 7)
        
        attributeString.addAttributes([
            .paragraphStyle: style,
            .font: Screen.Backup.descriptionFont,
            .foregroundColor: Configuration.Color.Semantic.defaultForegroundText
        ], range: NSRange(location: 0, length: description.count))
        
        return attributeString
    } 
}
