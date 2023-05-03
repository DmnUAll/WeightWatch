//
//  MainScreenController.swift
//  WeightWatch
//
//  Created by Илья Валито on 02.05.2023.
//

import UIKit

// MARK: - MainScreenController
final class MainScreenController: UIViewController {

    // MARK: - Properties and Initializers
    private var viewModel: MainScreenViewModel?

    private let scrollView = UICreator.shared.makeScrollView()
    private let weightMonitorLabel = UICreator.shared.makeLabel(text: "WEIGHT_MONITOR".localized)
    private let weightMonitorView = UICreator.shared.makeView(cornerRadius: 12)
    private let currentWeightLabel = UICreator.shared.makeLabel(text: "CURRENT_WEIGHT".localized,
                                                                font: UIFont.appFont(.bold, withSize: 13),
                                                                color: .wwText.withAlphaComponent(0.4))
    private let weightStackView = UICreator.shared.makeStackView()
    private let weightLabel = UICreator.shared.makeLabel(text: "NO_DATA".localized,
                                                         font: UIFont.appFont(.bold, withSize: 22))
    private let gainLossLabel = UICreator.shared.makeLabel(text: "NO_DATA".localized,
                                                           font: UIFont.appFont(.regular, withSize: 17),
                                                           color: .wwText.withAlphaComponent(0.6),
                                                           alignment: .left)
    private let scaleSystemStackView = UICreator.shared.makeStackView(alignment: .center, addingSpacing: 18)
    private let scaleSystemSwitch = UICreator.shared.makeSwitch(withAction: #selector(scaleSystemSwitchTapped))
    private let metricSystemLabel = UICreator.shared.makeLabel(text: "METRIC_SYSTEM".localized)
    private let imageView = UICreator.shared.makeImageView(withImageNamed: K.ImageNames.weights)
    private let monthlyMeasurementsLabel = UICreator.shared.makeLabel(text: "MONTHLY_MEASUREMENTS".localized)
    private let graphicPlugView = UICreator.shared.makeView(cornerRadius: 12)
    private let historyLabel = UICreator.shared.makeLabel(text: "HISTORY".localized)
    private let weightHeaderLabel = UICreator.shared.makeLabel(text: "WEIGHT".localized,
                                                               font: UIFont.appFont(.bold, withSize: 13),
                                                               color: .wwText.withAlphaComponent(0.4),
                                                               alignment: .left)
    private let changesHeaderLabel = UICreator.shared.makeLabel(text: "CHANGES".localized,
                                                                font: UIFont.appFont(.bold, withSize: 13),
                                                                color: .wwText.withAlphaComponent(0.4),
                                                                alignment: .left)
    private let dateHeaderLabel = UICreator.shared.makeLabel(text: "DATE".localized,
                                                             font: UIFont.appFont(.bold, withSize: 13),
                                                             color: .wwText.withAlphaComponent(0.4),
                                                             alignment: .left)
    private let headerStackView = UICreator.shared.makeStackView(alignment: .center, distribution: .fillEqually)
    private let headerLine = UICreator.shared.makeView(bacgroundColor: .wwLine)
    private let tableView = UICreator.shared.makeTable(
        withCells: (type: WeightTrackingCell.self, identifier: K.CellIdentifiers.weightTrackingCell))

    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .wwBackground
        setupAutolayout()
        addSubviews()
        setupConstraints()
        viewModel = MainScreenViewModel()
        bind()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - Helpers
extension MainScreenController {

    @objc private func scaleSystemSwitchTapped() {
        print(#function)
    }

    private func setupAutolayout() {
        scrollView.toAutolayout()
        weightMonitorLabel.toAutolayout()
        weightMonitorView.toAutolayout()
        currentWeightLabel.toAutolayout()
        weightStackView.toAutolayout()
        scaleSystemStackView.toAutolayout()
        imageView.toAutolayout()
        monthlyMeasurementsLabel.toAutolayout()
        graphicPlugView.toAutolayout()
        historyLabel.toAutolayout()
        headerStackView.toAutolayout()
        headerLine.toAutolayout()
        tableView.toAutolayout()
    }

    private func addSubviews() {
        scrollView.addSubview(weightMonitorLabel)
        weightMonitorView.addSubview(currentWeightLabel)
        weightStackView.addArrangedSubview(weightLabel)
        weightStackView.addArrangedSubview(gainLossLabel)
        weightMonitorView.addSubview(weightStackView)
        scaleSystemStackView.addArrangedSubview(scaleSystemSwitch)
        scaleSystemStackView.addArrangedSubview(metricSystemLabel)
        weightMonitorView.addSubview(scaleSystemStackView)
        weightMonitorView.addSubview(imageView)
        scrollView.addSubview(weightMonitorView)
        scrollView.addSubview(monthlyMeasurementsLabel)
        scrollView.addSubview(graphicPlugView)
        scrollView.addSubview(historyLabel)
        headerStackView.addArrangedSubview(weightHeaderLabel)
        headerStackView.addArrangedSubview(changesHeaderLabel)
        headerStackView.addArrangedSubview(dateHeaderLabel)
        scrollView.addSubview(headerStackView)
        scrollView.addSubview(headerLine)
        scrollView.addSubview(tableView)
        view.addSubview(scrollView)
    }

    private func setupConstraints() {
        let inset: CGFloat = 16
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            weightMonitorLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            weightMonitorLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            weightMonitorView.topAnchor.constraint(equalTo: weightMonitorLabel.bottomAnchor, constant: 24),
            weightMonitorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            weightMonitorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            currentWeightLabel.leadingAnchor.constraint(equalTo: weightMonitorView.leadingAnchor, constant: inset),
            currentWeightLabel.topAnchor.constraint(equalTo: weightMonitorView.topAnchor, constant: 16),
            weightStackView.leadingAnchor.constraint(equalTo: weightMonitorView.leadingAnchor, constant: inset),
            weightStackView.topAnchor.constraint(equalTo: currentWeightLabel.bottomAnchor, constant: 6),
            scaleSystemStackView.leadingAnchor.constraint(equalTo: weightMonitorView.leadingAnchor, constant: inset),
            scaleSystemStackView.topAnchor.constraint(equalTo: weightStackView.bottomAnchor, constant: 18),
            scaleSystemStackView.bottomAnchor.constraint(equalTo: weightMonitorView.bottomAnchor, constant: -18),
            imageView.topAnchor.constraint(equalTo: weightMonitorView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: weightMonitorView.trailingAnchor),
            monthlyMeasurementsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            monthlyMeasurementsLabel.topAnchor.constraint(equalTo: weightMonitorView.bottomAnchor, constant: 16),
            graphicPlugView.heightAnchor.constraint(equalToConstant: 313),
            graphicPlugView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            graphicPlugView.topAnchor.constraint(equalTo: monthlyMeasurementsLabel.bottomAnchor, constant: 16),
            graphicPlugView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            historyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            historyLabel.topAnchor.constraint(equalTo: graphicPlugView.bottomAnchor, constant: 16),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            headerStackView.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            headerLine.heightAnchor.constraint(equalToConstant: 1),
            headerLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            headerLine.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 8),
            headerLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            tableView.topAnchor.constraint(equalTo: headerLine.bottomAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -inset)
        ])
    }

    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.$needToUpdateView.bind { [weak self] newValue in
            guard let self else { return }
            if newValue {
                // TODO: UI update logic is needed
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension MainScreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var frame = tableView.frame
        frame.size.height = tableView.contentSize.height * 1.7
        tableView.frame = frame
        return viewModel?.giveNumberOfRows() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height * 1.7).isActive = true
        return viewModel?.configureCell(forTableView: tableView, atIndexPath: indexPath) ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

// MARK: - UITableViewDelegate
extension MainScreenController: UITableViewDelegate {

}
