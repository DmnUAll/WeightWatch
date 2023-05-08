//
//  WeightNoteScreenController.swift
//  WeightWatch
//
//  Created by Илья Валито on 03.05.2023.
//

import UIKit

// MARK: - WeightNoteScreenController
final class WeightNoteScreenController: UIViewController {

    // MARK: - Properties and Initializers
    private var viewModel: WeightNoteScreenViewModel?

    let contentView = UICreator.shared.makeView(bacgroundColor: .clear)
    private let addWeightLabel = UICreator.shared.makeLabel(text: "ADD_WEIGHT".localized)
    private var isButtonMoved = false
    private var noteToEdit: WeightNote?

    private let tableView: UITableView = {
        let tableView = UICreator.shared.makeTable(
            withCells: (type: SelectedDateCell.self, identifier: K.CellIdentifiers.selectedDateCell),
            (type: DatePickerCell.self, identifier: K.CellIdentifiers.datePickerCell),
            (type: WeightCell.self, identifier: K.CellIdentifiers.weightCell))
        tableView.separatorStyle = .singleLine
        return tableView
    }()

    private let addButton = UICreator.shared.makeButton(withTitle: "ADD".localized,
                                                        andAction: #selector(addButtonTapped))

    convenience init(noteToEdit: WeightNote) {
        self.init()
        self.noteToEdit = noteToEdit
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .wwBackground
        view.addKeyboardHiddingFeature()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        setupAutolayout()
        addSubviews()
        setupConstraints()
        disableButton()
        if let noteToEdit {
            viewModel = WeightNoteScreenViewModel(noteToEdit: noteToEdit)
            addButton.setTitle("SAVE".localized, for: .normal)
            addWeightLabel.text = "NOTE_EDITING".localized
        } else {
            viewModel = WeightNoteScreenViewModel()
        }
        bind()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - Helpers
extension WeightNoteScreenController {

    @objc private func keyboardWillShow(notification: NSNotification) {
        viewModel?.hideDatePicker()
        // swiftlint:disable:next line_length
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if !isButtonMoved {
                addButton.frame.origin.y -= keyboardSize.height - 34
                isButtonMoved.toggle()
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        // swiftlint:disable:next line_length
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if isButtonMoved {
                addButton.frame.origin.y += keyboardSize.height - 34
                isButtonMoved.toggle()
            }
        }
    }

    @objc private func addButtonTapped() {
        if let topController = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController {
            let destinationViewController = topController as? MainScreenController
            if let viewModel = viewModel {
                destinationViewController?.addNote(viewModel.createNewNote())
            }
        }
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }

    private func setupAutolayout() {
        contentView.toAutolayout()
        addWeightLabel.toAutolayout()
        tableView.toAutolayout()
        addButton.toAutolayout()
    }

    private func addSubviews() {
        contentView.addSubview(addWeightLabel)
        contentView.addSubview(tableView)
        contentView.addSubview(addButton)
        view.addSubview(contentView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addWeightLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addWeightLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            tableView.heightAnchor.constraint(equalToConstant: 400),
            tableView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 48),
            addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.5),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.5),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
        ])
    }

    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.$canShowDatePicker.bind { [weak self] newValue in
            guard let self else { return }
            if newValue {
                tableView.performBatchUpdates {
                    self.tableView.insertRows(at: [IndexPath(row: 1, section: 0)],
                                              with: .automatic)
                } completion: { _ in }
            } else {
                tableView.performBatchUpdates {
                    self.tableView.deleteRows(at: [IndexPath(row: 1, section: 0)],
                                              with: .automatic)
                } completion: { _ in }
            }
        }
        viewModel.$canCreateNote.bind { [weak self] newValue in
            guard let self else { return }
            if newValue {
                self.enableButton()
            } else {
                self.disableButton()
            }
        }
        viewModel.$canUpdateDateLabel.bind { [weak self] newValue in
            guard let self else { return }
            if newValue {
                guard let cell = self.tableView.cellForRow(at: IndexPath(row: 0,
                                                                         section: 0)) as? SelectedDateCell else {
                    return
                }
                DispatchQueue.main.async {
                    cell.selectedDateLabel.text = self.viewModel?.giveSelectedDate() ?? ""
                }
            }
        }
    }

    private func disableButton() {
        addButton.isEnabled = false
        addButton.backgroundColor = .wwBackgroundGray
    }

    private func enableButton() {
        addButton.isEnabled = true
        addButton.backgroundColor = .wwPurple
    }
}

// MARK: TableViewDataSource
extension WeightNoteScreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.giveNumberOfRows() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = viewModel?.configureCell(atIndexPath: indexPath) else { return UITableViewCell() }
        return cell
    }
}

// MARK: TableViewDelegate
extension WeightNoteScreenController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            viewModel?.showOrHideDatePicker()
        }
    }
}
