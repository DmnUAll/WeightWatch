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
    @Observable
    private(set) var needToUpdateView: Bool = false

    private var isDatePickerVisible = false
}

// MARK: - Helpers
extension WeightNoteScreenViewModel {
    func showDatePicker() {
        isDatePickerVisible = true
        needToUpdateView = true
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
            cell = isDatePickerVisible ? DatePickerCell() : WeightCell()
        case 2:
            cell = WeightCell()
        default:
            return cell
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.selectionStyle = .none
        return cell
    }
}
