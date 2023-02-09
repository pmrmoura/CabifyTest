//
//  Discount.swift
//  CabifyTest
//
//  Created by Pedro Moura on 05/02/23.
//

import Foundation

struct DiscountResponse: Codable {
    let discounts: [Discount]
}

class Discount: Codable {
    // TODO: Think in other names more significant // DONE
    let numberOfPiecesNeeded: Double
    let discountReceived: Double
    let discountType: String
    let productCode: String
    
    lazy var discountTypeType = DiscountType(rawValue: discountType)
    
    enum DiscountType: String {
        // TODO: Change name for bulk discount and 2for1 discount // DONE
        case bulk,
             twoForOne
    }
}
