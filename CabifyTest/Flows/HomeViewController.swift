//
//  HomeViewController.swift
//  CabifyTest
//
//  Created by Pedro Moura on 02/02/23.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    // MARK: - Private properties
    private typealias CellType = HomeViewModel.CellType
    
    private lazy var dataSource = makeDiffableDataSource()

    private lazy var tableViewController = makeTableViewController()
    private var tableView: UITableView {
        tableViewController.tableView
    }
    private lazy var checkoutButton = makeCheckoutButton()
    
    private var cancelBag = Set<AnyCancellable>()
    
    private let viewModel: HomeViewModel
    
    required init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setupView()
        setupTableViewSnapshotBinding()
        setupBindings()
        viewModel.fetchData()
    }
    
    enum Constants {
        static let checkoutButtonTitle = "Checkout"
    }
}

// MARK: - Setup

extension HomeViewController {
    private func setupView() {
        view.backgroundColor = .white
        
        setupViewHierarchy()
        setupConstraints()
    }
    
    private func setupViewHierarchy() {
        addChild(tableViewController)
        tableViewController.didMove(toParent: self)
        
        view.addSubview(tableViewController.view)
        view.addSubview(checkoutButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor),
            
            checkoutButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            checkoutButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func setupBindings() {
        viewModel.alertPublisher
            .sink(receiveValue: { [weak self] alertInformation in
                self?.presentAlertController(alertInformation: alertInformation)
            })
            .store(in: &cancelBag)
    }
        
    private func registerCells() {
        tableView
            .registerCell(cellClass: ProductTableViewCell.self)
    }
}

// MARK: - Cells

extension HomeViewController {
    private func cellForType(_ type: CellType, forIndexPath: IndexPath) -> UITableViewCell {
        switch type {
        case .product(let viewModel):
            return cellForProductTableViewCellViewModel(viewModel: viewModel, forIndexPath: forIndexPath)
        }
    }
}

// MARK: - Cell configuration

extension HomeViewController {
    private func cellForProductTableViewCellViewModel(viewModel: ProductTableViewCellViewModel, forIndexPath: IndexPath) -> UITableViewCell {
        viewModel.productOperationPublisher
            .sink(receiveValue: { [weak self] operation in
                self?.viewModel.executeCartOperation(operation)
            })
            .store(in: &cancelBag)
        let cell = tableView.dequeue(cellClass: ProductTableViewCell.self, indexPath: forIndexPath)
        cell.render(viewModel: viewModel)
        return cell
    }
}

// MARK: - Actions

extension HomeViewController {
    @objc private func checkoutButtonClicked() {
        viewModel.checkoutButtonClicked()
    }
}

// MARK: - Bindings

extension HomeViewController {
    private func setupTableViewSnapshotBinding() {
        viewModel.snapshot
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] snapshot in
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            })
            .store(in: &cancelBag)
    }
}

// MARK: - Setup components

extension HomeViewController {
    private func makeTableViewController() -> UITableViewController {
        let controller = UITableViewController(nibName: nil, bundle: nil)
        controller.tableView.rowHeight = UITableView.automaticDimension
        controller.tableView.estimatedRowHeight = UITableView.automaticDimension
        controller.tableView.separatorStyle = .none
        controller.tableView.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }
    
    private func makeCheckoutButton() -> UIButton {
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.title = Constants.checkoutButtonTitle
        buttonConfiguration.baseBackgroundColor = UIColor.purple

        let button = UIButton(configuration: buttonConfiguration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(checkoutButtonClicked), for: .touchUpInside)
        return button
    }
    
    private func makeDiffableDataSource() -> UITableViewDiffableDataSource<HomeViewModel.Section, CellType> {
        return UITableViewDiffableDataSource(tableView: tableView) { [weak self] _, indexPath, cellType in
            self?.cellForType(cellType, forIndexPath: indexPath)
        }
    }
}

// MARK: - Alert configuration

extension HomeViewController {
    func presentAlertController(alertInformation: AlertInformation) {
        let alert = UIAlertController(title: alertInformation.title, message: alertInformation.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: alertInformation.buttonText, style: .default))
        present(alert, animated: true, completion: nil)
    }
}