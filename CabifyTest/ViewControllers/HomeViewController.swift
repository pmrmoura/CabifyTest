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
        viewModel.fetchData()
    }
}

// MARK: - Setup

extension HomeViewController {
    private func setupView() {
        addChild(tableViewController)
        tableViewController.didMove(toParent: self)
        
        view.addSubview(tableViewController.view)
        tableView.pin(to: view, top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func setupBindings() {}
    
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
        let cell = tableView.dequeue(cellClass: ProductTableViewCell.self, indexPath: forIndexPath)
        return cell
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

// MARK: - Setup UI Components

extension HomeViewController {
    private func makeTableViewController() -> UITableViewController {
        let controller = UITableViewController(nibName: nil, bundle: nil)
        controller.tableView.rowHeight = UITableView.automaticDimension
        controller.tableView.estimatedRowHeight = UITableView.automaticDimension
        controller.tableView.separatorStyle = .none
        controller.tableView.accessibilityIdentifier = "UITableViewController[1]"
        return controller
    }
    
    private func makeDiffableDataSource() -> UITableViewDiffableDataSource<HomeViewModel.Section, CellType> {
        return UITableViewDiffableDataSource(tableView: tableView) { [weak self] _, indexPath, cellType in
            self?.cellForType(cellType, forIndexPath: indexPath)
        }
    }
}
