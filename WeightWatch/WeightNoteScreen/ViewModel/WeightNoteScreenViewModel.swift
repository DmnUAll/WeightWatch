//
//  WeightNoteScreenViewModel.swift
//  WeightWatch
//
//  Created by Илья Валито on 03.05.2023.
//

import UIKit

// MARK: - WeightNoteScreenViewModel
final class WeightNoteScreenViewModel {

    // MARK: - Properties and Initializers
    @Observable private(set) var canShowDatePicker: Bool = false
    @Observable private(set) var canUpdateDateLabel: Bool = false
    @Observable private(set) var canCreateNote: Bool = false

    private var isDatePickerVisible = false
    private var date: Date = Date()
    private var weight: Float = 0.0
    private var id: UUID?

    convenience init(noteToEdit: WeightNote) {
        self.init()
        prepareDataForEditing(noteToEdit)
    }
}

// MARK: - Helpers
extension WeightNoteScreenViewModel {

    func prepareDataForEditing(_ noteToEdit: WeightNote) {
        date = noteToEdit.date
        weight = noteToEdit.weightKG
        id = noteToEdit.id
    }

    func showOrHideDatePicker() {
        if isDatePickerVisible {
            hideDatePicker()
        } else {
            isDatePickerVisible = true
            canShowDatePicker = true
        }
    }

    func hideDatePicker() {
        if isDatePickerVisible {
            isDatePickerVisible = false
            canShowDatePicker = false
        }
    }

    func giveNumberOfRows() -> Int {
        isDatePickerVisible ? 3 : 2
    }

    func configureCell(atIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            cell = SelectedDateCell()
            let image = UIImage(named: K.IconNames.chevron)
            let chevron  = UIImageView(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: (image?.size.width) ?? 0,
                                                     height: (image?.size.height) ?? 0))
            chevron.image = image?.withTintColor(.wwText, renderingMode: .alwaysOriginal)
            cell.accessoryView = chevron
        case 1:
            cell = isDatePickerVisible ? DatePickerCell(delegate: self) : WeightCell(delegate: self)
        case 2:
            cell = WeightCell(delegate: self)
        default:
            return cell
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.selectionStyle = .none
        if let cell = cell as? SelectedDateCell {
            cell.selectedDateLabel.text = date.dateString == Date().dateString ? "TODAY".localized : date.dateString
        }
        if let cell = cell as? DatePickerCell {
            cell.datePicker.date = date
        }
        if let cell = cell as? WeightCell {
            if UserDefaultsManager.shared.isMetricSystemEnabled {
                cell.weightTextField.text = weight > 0 ? weight.asString : ""
                cell.weightMeasurementLabel.text = "KG".localized
            } else {
                cell.weightTextField.text = weight > 0 ? (weight * 2.205).asString : ""
                cell.weightMeasurementLabel.text = "LB".localized
            }
        }
        return cell
    }

    func giveSelectedDate() -> String {
        date.dateString
    }

    func createNewNote() -> WeightNote {
        var weightToSave = weight
        if !UserDefaultsManager.shared.isMetricSystemEnabled {
            weightToSave = weight / 2.205
        }
        return WeightNote(id: id ?? UUID(), weightKG: weightToSave, date: date)
    }
}

// MARK: DatePickerCellDelegate
extension WeightNoteScreenViewModel: DatePickerCellDelegate {

    func userPickedNewDate(_ date: Date) {
        self.date = date
        canUpdateDateLabel = true
    }
}

// MARK: WeightCellDelegate
extension WeightNoteScreenViewModel: WeightCellDelegate {

    func userEnteredWeight(_ weight: Float) {
        self.weight = weight
    }

    func canContinue(_ state: Bool) {
        canCreateNote = state
    }
}
