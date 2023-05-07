//
//  DatePickerCell.swift
//  WeightWatch
//
//  Created by Илья Валито on 03.05.2023.
//

import UIKit

// MARK: - DatePickerCellDelegate protocol
protocol DatePickerCellDelegate: AnyObject {
    func userPickedNewDate(_ date: Date)
}

// MARK: - DatePickerCell
final class DatePickerCell: UITableViewCell {

    // MARK: - Properties and Initializers
    weak var delegate: DatePickerCellDelegate?

    private let datePicker: UIDatePicker = {
        let datePicker = UICreator.shared.makeDatePicker()
        datePicker.addTarget(nil, action: #selector(datePickerValueChanged), for: .valueChanged)
        return datePicker
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAutolayout()
        addSubviews()
        setupConstraints()
        self.isAccessibilityElement = true
        contentView.isUserInteractionEnabled = false
    }

    convenience init(delegate: DatePickerCellDelegate) {
        self.init()
        self.delegate = delegate
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Helpers
extension DatePickerCell {

    @objc private func datePickerValueChanged() {
        delegate?.userPickedNewDate(datePicker.date)
    }

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
