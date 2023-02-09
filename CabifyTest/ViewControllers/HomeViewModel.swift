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
    let checkoutButtonPublisher = PassthroughSubject<Cart, Never>()
    
    // MARK: Private properties
    
    private var cells: [CellType] = [] {
        didSet {
            updateSnapshot()
        }
    }
    
    private var cart = Cart()
    private var products: [Product] = []
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellType>()
        snapshot.appendSections([.first])
        snapshot.appendItems(cells)
        self.snapshot.send(snapshot)
    }
}

// MARK: - External actions

extension HomeViewModel {
    func fetchData() {
        ProductService
            .getAllProducts { [weak self] result in
                switch result {
                case .success(let products):
                    self?.products = products
                    self?.cells = self?.makeCells() ?? []
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
    }
    
    func executeCartOperation(_ operation: ProductTableViewCellViewModel.ProductCartOperation) {
        switch operation {
        case .addProduct(let product):
            cart.addProduct(product)
        case .removeProduct(let product):
            cart.removeProduct(product)
        }
    }
    
    func checkoutButtonClicked() {
        checkoutButtonPublisher.send(cart)
    }
}

// MARK: - Cell configurations

extension HomeViewModel {
    private func makeCells() -> [CellType] {
        var cells: [CellType] = []
        
        products.forEach {
            cells.append(.product(viewModel: makeProductTableViewCellViewModel(product: $0)))
        }
        
        return cells
    }
    
    private func makeProductTableViewCellViewModel(product: Product) -> ProductTableViewCellViewModel {
        ProductTableViewCellViewModel(product: product, productCellType: .home)
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
}
