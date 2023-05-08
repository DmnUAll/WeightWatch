//
//  MainScreenViewModel.swift
//  WeightWatch
//
//  Created by Илья Валито on 02.05.2023.
//

import UIKit

// MARK: - MainScreenViewModel
final class MainScreenViewModel {

    // MARK: - Properties and Initializers
    @Observable private(set) var needToUpdateView: Bool = false
    @Observable private(set) var needToShowToastNewNoteMessage: Bool = false
    @Observable private(set) var needToShowToastNoteEditedMessage: Bool = false

    private let weightNoteStore = WeightNoteStore()

    private var weightNotes: [WeightNote] = []
}

// MARK: - Helpers
extension MainScreenViewModel {

    func checkForData() {
        weightNotes = weightNoteStore.weightNotes.sorted(by: { $0.date > $1.date })
        if !weightNotes.isEmpty {
            needToUpdateView = true
        }
    }
    func giveNumberOfRows() -> Int {
        weightNotes.count
    }

    func giveActualWeight() -> String? {
        if let actualNote = weightNotes.first {
            if UserDefaultsManager.shared.isMetricSystemEnabled {
                return "\(actualNote.weightKG.asString) \("KG".localized)"
            } else {
                return "\(actualNote.weightLB.asString) \("LB".localized)"
            }
        }
        return nil
    }

    func giveActualWeightChange() -> String? {
        if let actualNote = weightNotes.first {
            if UserDefaultsManager.shared.isMetricSystemEnabled {
                return "\(actualNote.changesKG.asStringWithSign) \("KG".localized)"
            } else {
                return "\(actualNote.changesLB.asStringWithSign) \("LB".localized)"
            }
        }
        return nil
    }

    func configureCell(forTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.weightTrackingCell,
                                                       for: indexPath) as? WeightTrackingCell else {
            return UITableViewCell()
        }
        if UserDefaultsManager.shared.isMetricSystemEnabled {
            cell.weightLabel.text = "\(weightNotes[indexPath.row].weightKG.asString) \("KG".localized)"
            cell.changesLabel.text = "\(weightNotes[indexPath.row].changesKG.asStringWithSign) \("KG".localized)"
        } else {
            cell.weightLabel.text = "\(weightNotes[indexPath.row].weightLB.asString) \("LB".localized)"
            cell.changesLabel.text = "\(weightNotes[indexPath.row].changesLB.asStringWithSign) \("LB".localized)"
        }
        cell.dateLabel.text = weightNotes[indexPath.row].date.dateString

        let image = UIImage(named: K.IconNames.chevron)
        let chevron  = UIImageView(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: (image?.size.width) ?? 0,
                                                 height: (image?.size.height) ?? 0))
        chevron.image = image?.withTintColor(.wwText, renderingMode: .alwaysOriginal)
        cell.accessoryView = chevron
        cell.selectionStyle = .none
        return cell
    }

    func giveSelectedNote(at indexPath: IndexPath) -> WeightNote {
        weightNotes[indexPath.row]
    }

    func giveCurrentScaleSystemState() -> Bool {
        UserDefaultsManager.shared.isMetricSystemEnabled
    }
    func changeToMetricSystem(_ state: Bool) {
        UserDefaultsManager.shared.saveScaleSystemState(state)
        needToUpdateView = true
    }

    func addNote(_ weightNote: WeightNote) {
        if let noteToDelete = weightNotes.first(where: { $0.id == weightNote.id }) {
            weightNotes.removeAll { $0.id == weightNote.id }
            weightNoteStore.deleteNote(noteToDelete)
            needToShowToastNoteEditedMessage = true
        } else {
            needToShowToastNewNoteMessage = true
        }
        weightNotes.append(weightNote)
        recalculateNotesWeightChange()
        needToUpdateView = true
    }

    func deleteNote(at indexPath: IndexPath) {
        let noteToDelete = weightNotes.remove(at: indexPath.row)
        weightNoteStore.deleteNote(noteToDelete)
        recalculateNotesWeightChange()
        needToUpdateView = true
    }

    private func recalculateNotesWeightChange() {
        weightNotes.sort(by: { $0.date < $1.date })
        for index in 0..<weightNotes.count {
            var currentNote = weightNotes[index]
            weightNoteStore.deleteNote(currentNote)
            if index != 0 {
                let previousNote = weightNotes[index - 1]
                currentNote.changesKG = currentNote.weightKG - previousNote.weightKG
            } else {
                currentNote.changesKG = 0.0
            }
            weightNotes.remove(at: index)
            weightNotes.insert(currentNote, at: index)
            weightNoteStore.addNewNote(currentNote)
        }
        weightNotes.reverse()
    }
}
