//
//  UIFont+Extensions.swift
//  WeightWatch
//
//  Created by Илья Валито on 02.05.2023.
//

import UIKit

extension UIFont {

    enum AppFonts: String {
        case display = "SF Pro Display Regular"
        case displaySemibold = "SF Pro Display Semibold"
        case displayBold = "SF Pro Display Bold"
        case text = "SF Pro Text Regular"
        case textMedium = "SF Pro Text Medium"
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

    static func checkExistingFontNames() {
        for fontFamilyName in UIFont.familyNames {
            for fontName in UIFont.fontNames(forFamilyName: fontFamilyName) {
                print("Family: \(fontFamilyName)     Font: \(fontName)")
            }
        }
    }
}
