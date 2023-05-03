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
    @Observable
    private(set) var needToUpdateView: Bool = false

    private var weightNotes: [WeightNote] = [WeightNote(weightKG: 1, changesKG: 0.0, date: Date()),
                                             WeightNote(weightKG: 2, changesKG: 0.0, date: Date()),
                                             WeightNote(weightKG: 3, changesKG: 0.0, date: Date()),
                                             WeightNote(weightKG: 4, changesKG: 0.0, date: Date()),
                                             WeightNote(weightKG: 5, changesKG: 0.0, date: Date()),
                                             WeightNote(weightKG: 6, changesKG: 0.0, date: Date()),
                                             WeightNote(weightKG: 7, changesKG: 0.0, date: Date()),
                                             WeightNote(weightKG: 8, changesKG: 0.0, date: Date()),
                                             WeightNote(weightKG: 9, changesKG: 0.0, date: Date())]
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
        cell.weightLabel.text = weightNotes[indexPath.row].weightKG.asString
        cell.changesLabel.text = weightNotes[indexPath.row].changesKG.asString
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
}
