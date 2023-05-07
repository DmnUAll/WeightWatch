//
//  WeightNote.swift
//  WeightWatch
//
//  Created by Илья Валито on 03.05.2023.
//

import Foundation

struct WeightNote {

    let id: UUID
    var weightKG: Float
    var weightLB: Float {
        weightKG * 2.205
    }
    var changesKG: Float
    var changesLB: Float {
        changesKG * 2.205
    }
    var date: Date

    init(id: UUID, weightKG: Float, changesKG: Float = 0.0, date: Date) {
        self.id = id
        self.weightKG = weightKG
        self.changesKG = changesKG
        self.date = date
    }
}
