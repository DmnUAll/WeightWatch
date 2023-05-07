//
//  UserDefaultsManager.swift
//  WeightWatch
//
//  Created by Илья Валито on 07.05.2023.
//

import Foundation

// MARK: - UserDefaultsManager
final class UserDefaultsManager {

    static var shared = UserDefaultsManager()

    private enum Keys: String {
        case isMetricSystem
    }

    private let userDefaults = UserDefaults.standard

    private(set) var isMetricSystemEnabled: Bool {
        get {
            loadUserDefaults(for: .isMetricSystem, as: Bool.self) ?? true
        }
        set {
            saveUserDefaults(value: newValue, at: .isMetricSystem)
        }
    }

    // MARK: - Data Manipulation Methods
    private func loadUserDefaults<T: Codable>(for key: Keys, as dataType: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue),
              let count = try? JSONDecoder().decode(dataType.self, from: data) else {
            return nil
        }
        return count
    }

    private func saveUserDefaults<T: Codable>(value: T, at key: Keys) {
        guard let data = try? JSONEncoder().encode(value) else {
            print("Unable to save data")
            return
        }
        userDefaults.set(data, forKey: key.rawValue)
    }

    func saveScaleSystemState(_ state: Bool) {
        isMetricSystemEnabled = state
    }
}
