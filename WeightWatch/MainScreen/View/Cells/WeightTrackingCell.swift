//
//  WeightTrackingCell.swift
//  WeightWatch
//
//  Created by Илья Валито on 03.05.2023.
//

import UIKit

// MARK: - WeightTrackingCell
final class WeightTrackingCell: UITableViewCell {

    // MARK: - Properties and Initializers
    let weightLabel = UICreator.shared.makeLabel(font: UIFont.appFont(.medium, withSize: 17),
                                                 alignment: .left)
    let changesLabel = UICreator.shared.makeLabel(font: UIFont.appFont(.medium, withSize: 17),
                                                  color: .wwText.withAlphaComponent(0.6),
                                                  alignment: .left)
    let dateLabel = UICreator.shared.makeLabel(font: UIFont.appFont(.medium, withSize: 17),
                                               color: .wwText.withAlphaComponent(0.4),
                                               alignment: .left)
    private let stackView = UICreator.shared.makeStackView(alignment: .center, distribution: .fillEqually)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAutolayout()
        addSubviews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Helpers
extension WeightTrackingCell {

    private func setupAutolayout() {
        stackView.toAutolayout()
    }

    private func addSubviews() {
        stackView.addArrangedSubview(weightLabel)
        stackView.addArrangedSubview(changesLabel)
        stackView.addArrangedSubview(dateLabel)
        addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
