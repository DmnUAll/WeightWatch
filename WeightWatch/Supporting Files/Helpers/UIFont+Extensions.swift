//
//  UIFont+Extensions.swift
//  WeightWatch
//
//  Created by Илья Валито on 02.05.2023.
//

import UIKit

extension UIFont {

    enum AppFonts: String {
        case regular = "SFPro-Regular"
        case medium = "SFPro-Medium"
        case bold = "SFPro-Bold"
    }

    static func appFont(_ style: AppFonts, withSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: style.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: 8)
        }
        return font
    }
}
