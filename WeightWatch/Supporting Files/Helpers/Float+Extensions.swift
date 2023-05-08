//
//  Float+Extensions.swift
//  WeightWatch
//
//  Created by Илья Валито on 03.05.2023.
//

import Foundation

extension Float {

    var asStringWithSign: String {
        if self.truncatingRemainder(dividingBy: 1.0) == 0.0 {
            return "\(self <= 0 ? "" : "+")\(Int(self))".replacingOccurrences(of: ".", with: ",")
        } else {
            return "\(self <= 0 ? "" : "+")\(String(format: "%.1f", self))".replacingOccurrences(of: ".", with: ",")
        }
    }

    var asString: String {
        if self.truncatingRemainder(dividingBy: 1.0) == 0.0 {
            return "\(Int(self))"
        } else {
            return String(format: "%.1f", self).replacingOccurrences(of: ".", with: ",")
        }
    }
}
