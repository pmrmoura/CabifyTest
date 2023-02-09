//
//  Cart.swift
//  CabifyTest
//
//  Created by Pedro Moura on 03/02/23.
//

import Foundation
import Combine

final class Cart {
    var products: [Product]
    var productsMap: [String: Double]
    var activeDiscounts: [Discount]
    
    let service: DiscountServiceInterface
    
    private var cancelBag = Set<AnyCancellable>()
    
    init(products: [Product] = [],
         productsMap: [String: Double] = [:],
         activeDiscounts: [Discount] = [],
         service: DiscountServiceInterface = DiscountService()) {
        self.products = products
        self.productsMap = productsMap
        self.activeDiscounts = activeDiscounts
        self.service = service
        fetchActiveDiscounts()
    }
    
    func isCartEmpty() -> Bool {
        products.isEmpty
    }
    
    func addProduct(_ product: Product) {
        products.append(product)
        productsMap[product.code, default: 0] += 1
    }
    
    func removeProduct(_ product: Product) {
        guard let index = products.firstIndex(of: product) else { return }
        products.remove(at: index)
        productsMap[product.code, default: 0] -= 1
        if productsMap[product.code] == 0 {
            productsMap.removeValue(forKey: product.code)
        }
    }
    
    func calculateSubtotal() -> Double {
        return products.reduce(0) { $0 + $1.price }
    }
    
    func fetchActiveDiscounts() {
        service.fetchAllDiscounts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] result in
                self?.activeDiscounts = result
            })
            .store(in: &cancelBag)
    }
    
    func calculateFinalPrice() -> Double {
        calculateSubtotal() - calculateDiscount()
    }
    
    func calculateDiscount() -> Double {
        var discount: Double = 0
        activeDiscounts.forEach {
            guard let type = $0.discountTypeEnum, let productCount = productsMap[$0.productCode] else { return }
            switch type {
            case .bulk:
                if productCount >= $0.numberOfPiecesNeeded {
                    discount += productCount * $0.discountReceived
                }
            case .oneForFree:
                let numberOfTimesWillBeApplied = (Int(productCount)) / Int($0.numberOfPiecesNeeded)

                discount += Double(numberOfTimesWillBeApplied) * $0.discountReceived
            }
        }
        return discount
    }
}
