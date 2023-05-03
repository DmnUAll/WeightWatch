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

    private let addWeightLabel = UICreator.shared.makeLabel(text: "ADD_WEIGHT".localized)

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

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .wwBackground
        view.addKeyboardHiddingFeature()
        setupAutolayout()
        addSubviews()
        setupConstraints()
        viewModel = WeightNoteScreenViewModel()
        bind()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - Helpers
extension WeightNoteScreenController {

    @objc private func dateButtonTapped() {
        print(#function)
    }

    @objc private func addButtonTapped() {
        print(#function)
    }

    private func setupAutolayout() {
        addWeightLabel.toAutolayout()
        tableView.toAutolayout()
        addButton.toAutolayout()
    }

    private func addSubviews() {
        view.addSubview(addWeightLabel)
        view.addSubview(tableView)
        view.addSubview(addButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            addWeightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addWeightLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            tableView.heightAnchor.constraint(equalToConstant: 400),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15.5),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.5),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }

    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.$needToUpdateView.bind { [weak self] newValue in
            guard let self else { return }
            if newValue {
                tableView.reloadData()
            }
        }
    }
}

// MARK: TableViewDataSource
extension WeightNoteScreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.giveNumberOfRows() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel?.configureCell(atIndexPath: indexPath) ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: TableViewDelegate
extension WeightNoteScreenController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            viewModel?.showDatePicker()
        }
    }
}
