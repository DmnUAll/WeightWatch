//
//  UIViewController+Extensions.swift
//  WeightWatch
//
//  Created by Илья Валито on 08.05.2023.
//

import UIKit

extension UIViewController {

    func showToast(message: String, font: UIFont) {
        let labelWidth = self.view.frame.size.width - 16
        let toastLabel = UITextView(frame: CGRect(x: self.view.frame.size.width / 2 - labelWidth / 2,
                                               y: self.view.frame.size.height - 110,
                                               width: labelWidth,
                                               height: 52))
        toastLabel.backgroundColor = .wwText
        toastLabel.textColor = .wwBackground
        toastLabel.font = font
        toastLabel.textAlignment = .left
        toastLabel.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
