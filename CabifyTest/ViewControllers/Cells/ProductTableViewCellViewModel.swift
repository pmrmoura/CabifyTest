//
//  ProductTableViewCellViewModel.swift
//  CabifyTest
//
//  Created by Pedro Moura on 03/02/23.
//

import Foundation
import Combine

class ProductTableViewCellViewModel: ViewModelHashable {
    // MARK: - Private properties
    let product: CurrentValueSubject<Product, Never>
    let productOperationPublisher = PassthroughSubject<ProductCartOperation, Never>()
    
    init(product: Product) {
        self.product = CurrentValueSubject(product)
    }
    
    // MARK: - Enums
    
    enum ProductCartOperation {
        case addProduct(product: Product),
             removeProduct(product: Product)
    }
}

extension ProductTableViewCellViewModel {
    func productOperation(_ operation: ProductCartOperation) {
        productOperationPublisher.send(operation)
    }
}
