//
//  WeightCell.swift
//  WeightWatch
//
//  Created by Илья Валито on 03.05.2023.
//

import UIKit

// MARK: - WeightCell
final class WeightCell: UITableViewCell {

    // MARK: - Properties and Initializers
    private let stackView = UICreator.shared.makeStackView(alignment: .center, addingSpacing: 4)

    let weightTextField: UITextField = {
        let textField = UICreator.shared.makeTextField()
        textField.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        return textField
    }()

    let weightMeasurementLabel = UICreator.shared.makeLabel(text: "KG".localized.lowercased(),
                                                            font: UIFont.appFont(.medium, withSize: 17),
                                                            color: .wwText.withAlphaComponent(0.4),
                                                            alignment: .right)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAutolayout()
        addSubviews()
        setupConstraints()
        self.isAccessibilityElement = true
        contentView.isUserInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Helpers
extension WeightCell {

    private func setupAutolayout() {
        stackView.toAutolayout()
    }

    private func addSubviews() {
        stackView.addArrangedSubview(weightTextField)
        stackView.addArrangedSubview(weightMeasurementLabel)
        addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
