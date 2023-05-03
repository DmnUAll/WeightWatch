//
//  DatePickerCell.swift
//  WeightWatch
//
//  Created by Илья Валито on 03.05.2023.
//

import UIKit

// MARK: - DatePickerCell
final class DatePickerCell: UITableViewCell {

    // MARK: - Properties and Initializers
    private let datePicker = UICreator.shared.makeDatePicker()

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
extension DatePickerCell {

    private func setupAutolayout() {
        datePicker.toAutolayout()
    }

    private func addSubviews() {
        addSubview(datePicker)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            datePicker.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            datePicker.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25)
        ])
    }
}
