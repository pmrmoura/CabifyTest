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
        // TODO: Add function here to check if the user won a discount or is about to win when add a product
        products.append(product)
        if let productCode = productsMap[product.code] {
            productsMap[product.code] = productCode + 1
        } else {
            productsMap[product.code] = 1
        }
    }
    
    func removeProduct(_ product: Product) {
//        if let index = products.firstIndex(of: product) {
//            products.remove(at: index)
//        }
    }
    
    func clearCart() {
        products.removeAll()
    }
    
    func calculateFinalPrice() -> Double {
        return products.reduce(0) { $0 + $1.price }
    }
    
    func fetchActiveDiscounts() {
        let twoForOneDiscount = Discount(condition: 2, reduction: 5, discountType: .unique, productCode: "VOUCHER")
        let bulkDiscount = Discount(condition: 3, reduction: 1, discountType: .perUnit, productCode: "TSHIRT")
        
        activeDiscounts = [twoForOneDiscount, bulkDiscount]
    }
    
    func applyDiscounts() {
        // TODO: Refactor this crap
        var totalPrice = calculateFinalPrice()
        activeDiscounts.forEach {
            var newPrice: Double
            switch $0.discountType {
            case .perUnit:
                if productsMap[$0.productCode] ?? 0 >= $0.condition {
                    newPrice = totalPrice - (productsMap[$0.productCode] ?? 0) * $0.reduction
                    totalPrice = newPrice
                    print(newPrice)
                }
            case .unique:
                let numberOfTimesWillBeApplied = (Int(productsMap[$0.productCode] ?? 0)) / Int($0.condition)

                newPrice = totalPrice - Double(numberOfTimesWillBeApplied) * $0.reduction
                totalPrice = newPrice
                print(newPrice)
            }
        }
    }
}
