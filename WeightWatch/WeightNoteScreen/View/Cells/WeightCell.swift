//
//  WeightCell.swift
//  WeightWatch
//
//  Created by Илья Валито on 03.05.2023.
//

import UIKit

// MARK: - WeightCellDelegate protocol
protocol WeightCellDelegate: AnyObject {
    func userEnteredWeight(_ weight: Float)
    func canContinue(_ state: Bool)
}

// MARK: - WeightCell
final class WeightCell: UITableViewCell {

    // MARK: - Properties and Initializers
    weak var delegate: WeightCellDelegate?

    private let stackView = UICreator.shared.makeStackView(alignment: .center, addingSpacing: 4)

    let weightTextField: UITextField = {
        let textField = UICreator.shared.makeTextField()
        textField.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        return textField
    }()

    let weightMeasurementLabel = UICreator.shared.makeLabel(text: "KG".localized.lowercased(),
                                                            font: UIFont.appFont(.textMedium, withSize: 17),
                                                            color: .wwText.withAlphaComponent(0.4),
                                                            alignment: .right)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAutolayout()
        addSubviews()
        setupConstraints()
        self.isAccessibilityElement = true
        contentView.isUserInteractionEnabled = false
        weightTextField.delegate = self
    }

    convenience init(delegate: WeightCellDelegate) {
        self.init()
        self.delegate = delegate
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

// MARK: - UITextFieldDelegate
extension WeightCell: UITextFieldDelegate {

    // NOTE: This method works as expected on physical devices, but have troubles with input on virtual devices
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        if string == "," {
            textField.text = textField.text! + "."
            return false
        }
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.count == 0 {
            delegate?.canContinue(false)
        } else {
            if let updatedText = Float(updatedText),
               updatedText > 0,
               updatedText < (weightMeasurementLabel.text == "KG".localized ? 1000 : 1000 * 2.205) {
                delegate?.userEnteredWeight(updatedText)
                delegate?.canContinue(true)
                return true
            } else {
                return false
            }
        }
        return true
    }
}
