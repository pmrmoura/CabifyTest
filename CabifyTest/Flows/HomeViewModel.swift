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
    let alertPublisher = PassthroughSubject<AlertInformation, Never>()
    let service: ProductServiceInterface
    var cart: Cart
    
    // MARK: Private properties
    
    private var cells: [CellType] = [] {
        didSet {
            updateSnapshot()
        }
    }

    private var cancelBag = Set<AnyCancellable>()
    private var products: [Product] = []
    
    init(service: ProductServiceInterface = ProductService(),
         cart: Cart = Cart()) {
        self.service = service
        self.cart = cart
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellType>()
        snapshot.appendSections([.first])
        snapshot.appendItems(cells)
        self.snapshot.send(snapshot)
    }
    
    enum Constants {
        static let errorAlertTitle = "Error"
        static let cartEmptyAlertMessage = "The cart is empty, please add products"
        static let defaultAlertButtonText = "OK"
    }
}

// MARK: - External actions

extension HomeViewModel {
    func fetchData() {
        service.fetchAllProducts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    let alertInformation = AlertInformation(title: Constants.errorAlertTitle, message: error.localizedDescription, buttonText: Constants.defaultAlertButtonText)
                    self?.alertPublisher.send(alertInformation)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                self?.products = result
                self?.cells = self?.makeCells() ?? []
            })
            .store(in: &cancelBag)
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
        guard !cart.isCartEmpty() else {
            let alertInformation = AlertInformation(title: Constants.errorAlertTitle , message: Constants.cartEmptyAlertMessage, buttonText: Constants.defaultAlertButtonText)
            alertPublisher.send(alertInformation)
            return
        }
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
