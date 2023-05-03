//
//  Observable.swift
//  WeightWatch
//
//  Created by Илья Валито on 02.05.2023.
//

// MARK: - Observable
@propertyWrapper
final class Observable<Value> {

    private var onChange: ((Value) -> Void)?

    var wrappedValue: Value {
        didSet {
            onChange?(wrappedValue)
        }
    }

    var projectedValue: Observable<Value> {
        return self
    }

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    func bind(action: @escaping (Value) -> Void) {
        self.onChange = action
    }
}
