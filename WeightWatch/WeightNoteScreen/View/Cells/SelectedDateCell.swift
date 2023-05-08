//
//  SelectedDateCell.swift
//  WeightWatch
//
//  Created by Илья Валито on 03.05.2023.
//

import UIKit

// MARK: - SelectedDateCell
final class SelectedDateCell: UITableViewCell {

    // MARK: - Properties and Initializers
    private let dateLabel = UICreator.shared.makeLabel(text: "DATE".localized,
                                                       font: UIFont.appFont(.textMedium, withSize: 17))
    let selectedDateLabel = UICreator.shared.makeLabel(text: "TODAY".localized,
                                                       font: UIFont.appFont(.display, withSize: 17),
                                                       color: .wwPurple, alignment: .right)

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
extension SelectedDateCell {

    private func setupAutolayout() {
        dateLabel.toAutolayout()
        selectedDateLabel.toAutolayout()
    }

    private func addSubviews() {
        addSubview(dateLabel)
        addSubview(selectedDateLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.5),
            selectedDateLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 16.5),
            selectedDateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectedDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44.5)
        ])
    }
}
