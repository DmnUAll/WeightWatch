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

    private let weightNoteStore = WeightNoteStore()

    private var weightNotes: [WeightNote] = []

    init() {
        weightNotes = weightNoteStore.weightNotes.sorted(by: { $0.date > $1.date })
        if !weightNotes.isEmpty {
            needToUpdateView = true
        }
    }
}

// MARK: - Helpers
extension MainScreenViewModel {

    func giveNumberOfRows() -> Int {
        weightNotes.count
    }

    func configureCell(forTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.weightTrackingCell,
                                                       for: indexPath) as? WeightTrackingCell else {
            return UITableViewCell()
        }
        if UserDefaultsManager.shared.isMetricSystemEnabled {
            cell.weightLabel.text = weightNotes[indexPath.row].weightKG.asString
            cell.changesLabel.text = weightNotes[indexPath.row].changesKG.asString
        } else {
            cell.weightLabel.text = weightNotes[indexPath.row].weightLB.asString
            cell.changesLabel.text = weightNotes[indexPath.row].changesLB.asString
        }
        cell.dateLabel.text = weightNotes[indexPath.row].date.dateString

        let image = UIImage(named: K.IconNames.chevron)
        let chevron  = UIImageView(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: (image?.size.width) ?? 0,
                                                 height: (image?.size.height) ?? 0))
        chevron.image = image?.withTintColor(.wwText, renderingMode: .alwaysOriginal)
        cell.accessoryView = chevron
        return cell
    }

    func giveCurrentScaleSystemState() -> Bool {
        UserDefaultsManager.shared.isMetricSystemEnabled
    }
    func changeToMetricSystem(_ state: Bool) {
        UserDefaultsManager.shared.saveScaleSystemState(state)
        needToUpdateView = true
    }

    func addNote(_ weightNote: WeightNote) {
        weightNotes.append(weightNote)
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
        needToUpdateView = true
    }
}
