//
//  Discount.swift
//  CabifyTest
//
//  Created by Pedro Moura on 05/02/23.
//

import Foundation

final class Discount {
    // TODO: Think in other names more significant
    let condition: Double
    let reduction: Double
    let discountType: DiscountType
    let productCode: String
    
    init(condition: Double, reduction: Double, discountType: DiscountType, productCode: String) {
        self.condition = condition
        self.reduction = reduction
        self.discountType = discountType
        self.productCode = productCode
    }
    
    enum DiscountType {
        // TODO: Change name for bulk discount and 2for1 discount
        case perUnit,
             unique
    }
}
