// Copyright © 2020 Stormbird PTE. LTD.

import UIKit

class RoundedImageView: ImageView {

    init(size: CGSize) {
        super.init(frame: .zero)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}

class WalletConnectSessionCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let urlLabel = UILabel()
    private let iconImageView: RoundedImageView = {
        let imageView = RoundedImageView(size: DataEntry.Metric.Cell.imageSize)
        return imageView
    }()

    private let serverIconImageView: RoundedImageView = {
        let imageView = RoundedImageView(size: DataEntry.Metric.ChainOverlay.size)
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let cell0 = [
            nameLabel,
            urlLabel
        ].asStackView(axis: .vertical)
        let stackView = [.spacerWidth(5), iconImageView, .spacerWidth(12), cell0 ].asStackView(axis: .horizontal, alignment: .center)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        contentView.addSubview(serverIconImageView)

        NSLayoutConstraint.activate([
            serverIconImageView.centerXAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: 8),
            serverIconImageView.centerYAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: -8),
            //NOTE: using edge insets to avoid braking constraints
            stackView.anchorsConstraint(to: contentView, edgeInsets: DataEntry.Metric.Cell.insets)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel: WalletConnectSessionCellViewModel) {
        selectionStyle = .default
        backgroundColor = viewModel.backgroundColor
        nameLabel.attributedText = viewModel.sessionNameAttributedString
        urlLabel.attributedText = viewModel.sessionURLAttributedString
        iconImageView.setImage(url: viewModel.sessionIconURL, placeholder: R.image.walletConnectIcon())
    }
}
