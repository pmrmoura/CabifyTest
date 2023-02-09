//
//  Cart.swift
//  CabifyTest
//
//  Created by Pedro Moura on 03/02/23.
//

import Foundation

final class Cart {
    var products: [Product] = []
    var productsMap: [String: Double] = [:]
    var activeDiscounts: [Discount] = []
    
    init() {
        fetchActiveDiscounts()
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
        DiscountService
            .getAllDiscounts(completion: { [weak self] result in
                switch result {
                case .success(let discount):
                    self?.activeDiscounts = discount
                    print(discount)
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    func calculateFinalPrice() -> Double {
        calculateSubtotal() - calculateDiscount()
    }
    
    func calculateDiscount() -> Double {
        var discount: Double = 0
        activeDiscounts.forEach {
            let type = $0.discountTypeType
            switch type {
            case .bulk:
                if productsMap[$0.productCode] ?? 0 >= $0.numberOfPiecesNeeded {
                    discount += (productsMap[$0.productCode] ?? 0) * $0.discountReceived
                }
            case .twoForOne:
                let numberOfTimesWillBeApplied = (Int(productsMap[$0.productCode] ?? 0)) / Int($0.numberOfPiecesNeeded)

                discount += Double(numberOfTimesWillBeApplied) * $0.discountReceived
            case .none:
                // TODO: ????
                print("dede")
            }
        }
        return discount
    }
}
