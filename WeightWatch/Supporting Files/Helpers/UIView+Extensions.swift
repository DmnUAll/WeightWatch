//
//  UIView+Extensions.swift
//  WeightWatch
//
//  Created by Илья Валито on 02.05.2023.
//

import UIKit

extension UIView {

    func toAutolayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    func addKeyboardHiddingFeature() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
}
