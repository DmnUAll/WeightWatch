//
//  CoreDataManager.swift
//  WeightWatch
//
//  Created by Илья Валито on 07.05.2023.
//

import UIKit

// MARK: - CoreDataManager
struct CoreDataManager {
    // swiftlint:disable:next force_cast
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}
