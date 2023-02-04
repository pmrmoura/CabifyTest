//
//  ProductModels.swift
//  CabifyTest
//
//  Created by Pedro Moura on 02/02/23.
//

import Foundation

struct ProductResponse: Codable {
    let products: [Product]
}

struct Product: Codable {
    let code: String
    let name: String
    let price: Double
}
