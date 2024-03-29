// Copyright © 2018 Stormbird PTE. LTD.

import Foundation
import UIKit

class MyDappCell: UITableViewCell {
    private var iconImageViewHolder = ContainerViewWithShadow(aroundView: UIImageView())
    private let titleLabel = UILabel()
    private let urlLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        let labelsVerticalStackView = [
            titleLabel,
            urlLabel].asStackView(axis: .vertical)
        
        let mainStackView = [.spacerWidth(29), iconImageViewHolder, .spacerWidth(26), labelsVerticalStackView, .spacerWidth(29)].asStackView(axis: .horizontal, alignment: .center)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),

            iconImageViewHolder.widthAnchor.constraint(equalToConstant: 44),
            iconImageViewHolder.widthAnchor.constraint(equalTo: iconImageViewHolder.heightAnchor),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel: MyDappCellViewModel) {
        titleLabel.font = viewModel.nameFont
        titleLabel.textColor = viewModel.nameColor
        titleLabel.text = viewModel.title

        urlLabel.font = viewModel.domainNameFont
        urlLabel.textColor = viewModel.domainNameColor
        urlLabel.text = viewModel.domainName

        iconImageViewHolder.configureShadow(color: viewModel.imageViewShadowColor, offset: viewModel.imageViewShadowOffset, opacity: viewModel.imageViewShadowOpacity, radius: viewModel.imageViewShadowRadius, cornerRadius: iconImageViewHolder.frame.size.width / 2)

        let iconImageView = iconImageViewHolder.childView
        iconImageView.backgroundColor = viewModel.backgroundColor
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        iconImageView.kf.setImage(with: viewModel.imageUrl, placeholder: viewModel.fallbackImage)

        backgroundColor = .clear
        //TODO ugly hack to get the image view's frame. Can't figure out a good point to retrieve the correct frame otherwise
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.iconImageViewHolder.configureShadow(color: viewModel.imageViewShadowColor, offset: viewModel.imageViewShadowOffset, opacity: viewModel.imageViewShadowOpacity, radius: viewModel.imageViewShadowRadius, cornerRadius: self.iconImageViewHolder.frame.size.width / 2)
        }
    }
}
