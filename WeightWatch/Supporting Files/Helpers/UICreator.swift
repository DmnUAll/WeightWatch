//
//  UICreator.swift
//  WeightWatch
//
//  Created by Илья Валито on 02.05.2023.
//

import UIKit

// MARK: - UICreator
struct UICreator {

    static let shared = UICreator()

    func makeLabel(text: String? = nil,
                   font: UIFont = UIFont.appFont(.bold, withSize: 20),
                   color: UIColor = .wwText,
                   alignment: NSTextAlignment = .center,
                   andNumberOfLines numberOfLines: Int = 0
    ) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = color
        label.textAlignment = alignment
        label.numberOfLines = numberOfLines
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.text = text
        return label
    }

    func makeSwitch(withAction action: Selector, andCurrentState state: Bool = true) -> UISwitch {
        let uiSwitch = UISwitch()
        uiSwitch.isOn = state
        uiSwitch.addTarget(nil, action: action, for: UIControl.Event.valueChanged)
        uiSwitch.onTintColor = .wwPurple
        return uiSwitch
    }

    func makeView(bacgroundColor: UIColor = .wwBackgroundGray, cornerRadius: CGFloat? = nil) -> UIView {
        let uiView = UIView()
        uiView.backgroundColor = bacgroundColor
        if let cornerRadius {
            uiView.layer.cornerRadius = cornerRadius
            uiView.layer.masksToBounds = true
        }
        return uiView
    }

    func makeStackView(axis: NSLayoutConstraint.Axis = .horizontal,
                       alignment: UIStackView.Alignment = .bottom,
                       distribution: UIStackView.Distribution = .fill,
                       backgroundColor: UIColor = .clear,
                       addingSpacing spacing: CGFloat = 8
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.backgroundColor = backgroundColor
        stackView.spacing = spacing
        return stackView
    }

    func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }

    func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.textColor = .wwText
        textField.keyboardType = .numberPad
        textField.font =  UIFont.appFont(.bold, withSize: 34)
        return textField
    }

    func makeImageView(withImageNamed imageName: String? = nil
    ) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        if let imageName {
            imageView.image = UIImage(named: imageName)
        }
        return imageView
    }

    func makeButton(withTitle title: String = "",
                    image: UIImage? = nil,
                    backgroundColor: UIColor = .wwPurple,
                    tintColor: UIColor = .white,
                    cornerRadius: CGFloat = 10,
                    andAction selector: Selector
    ) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
        button.backgroundColor = backgroundColor
        button.tintColor = tintColor
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.appFont(.medium, withSize: 17)
        button.addTarget(nil, action: selector, for: .touchUpInside)
        return button
    }

    func makeDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = .clear
        datePicker.tintColor = .wwText
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ru")
        return datePicker
    }

    func makeTable(withCells cells: (type: UITableViewCell.Type, identifier: String)...) -> UITableView {
        let tableView = UITableView()
        tableView.toAutolayout()
        for singleCell in cells {
            tableView.register(singleCell.type, forCellReuseIdentifier: singleCell.identifier)
        }
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.isScrollEnabled = false
        return tableView
    }
}
