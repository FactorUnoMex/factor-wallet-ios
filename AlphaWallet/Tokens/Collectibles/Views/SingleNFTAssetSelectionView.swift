//
//  AssetSelectionCircleOverlayView.swift
//  AlphaWallet
//
//  Created by Vladyslav Shepitko on 07.09.2021.
//

import UIKit

class AssetSelectionCircleOverlayView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    init() {
        super.init(frame: .zero)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
        ])
        backgroundColor = Configuration.Color.Semantic.appTint
        translatesAutoresizingMaskIntoConstraints = false
    }

    func configure(viewModel: AssetSelectionCircleOverlayViewModel) {
        titleLabel.attributedText = viewModel.selectedAmountAttributedString
        isHidden = viewModel.isHidden
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2.0
    }
}

