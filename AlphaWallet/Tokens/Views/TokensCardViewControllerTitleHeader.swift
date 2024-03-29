// Copyright © 2018 Stormbird PTE. LTD.

import UIKit

class TokensCardViewControllerTitleHeader: UIView {
    private let background = UIView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        background.translatesAutoresizingMaskIntoConstraints = false
        addSubview(background)

        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let stackView = [titleLabel].asStackView(axis: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        background.addSubview(stackView)

        let backgroundWidthConstraint = background.widthAnchor.constraint(equalTo: widthAnchor)
        backgroundWidthConstraint.priority = .defaultHigh
        // TODO extract constant. Maybe DataEntry.Metric.sideMargin
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundWidthConstraint,

            stackView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: background.bottomAnchor, constant: -16),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String) {
        //Important to specify a non-zero rect the first time. Cannot (and don't need to) set subsequently because that will move the origin to 0,0
        if frame.size.width == 0 {
            frame = CGRect(x: 0, y: 0, width: 300, height: 90)
        }
        backgroundColor = Configuration.Color.Semantic.defaultViewBackground

        titleLabel.textColor = Configuration.Color.Semantic.defaultForegroundText
        titleLabel.font = Fonts.regular(size: 28)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.text = title
    }
}
