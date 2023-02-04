//
//  HomeViewModel.swift
//  CabifyTest
//
//  Created by Pedro Moura on 02/02/23.
//

import Combine
import UIKit

final class HomeViewModel {
    // MARK: Properties
    
    let snapshot: CurrentValueSubject<NSDiffableDataSourceSnapshot<Section, CellType>, Never> = CurrentValueSubject(NSDiffableDataSourceSnapshot())
    
    // MARK: Private properties
    
    private var cells: [CellType] = [] {
        didSet {
            updateSnapshot()
        }
    }
    
    private var cart = Cart()
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellType>()
        snapshot.appendSections([.first])
        snapshot.appendItems(cells)
        self.snapshot.send(snapshot)
    }
}

extension HomeViewModel {
    func fetchData() {
        cells = [.product(viewModel: ProductTableViewCellViewModel()), .product(viewModel: ProductTableViewCellViewModel()), .product(viewModel: ProductTableViewCellViewModel())]
    }
}

// MARK: - Cell types

extension HomeViewModel {
    enum CellType: Hashable {
        case product(viewModel: ProductTableViewCellViewModel)
    }
    
    enum Section: Hashable {
        case first
    }
    
    enum State {
        case idle,
             error
    }
}
