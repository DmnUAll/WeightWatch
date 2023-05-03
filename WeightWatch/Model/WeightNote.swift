//
//  WeightNote.swift
//  WeightWatch
//
//  Created by Илья Валито on 03.05.2023.
//

import Foundation

struct WeightNote {

    var weightKG: Float
    var weightLB: Float {
        weightKG * 2.205
    }
    var changesKG: Float
    var changesLB: Float {
        changesKG * 2.205
    }
    var date: Date
}
