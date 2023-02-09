//
//  ProductService.swift
//  CabifyTest
//
//  Created by Pedro Moura on 02/02/23.
//

import Foundation
import Combine

protocol ProductServiceInterface {
    func fetchAllProducts() -> AnyPublisher<[Product], Error>
}

final class ProductService: ProductServiceInterface {
    let baseURL = "https://gist.githubusercontent.com/palcalde/6c19259bd32dd6aafa327fa557859c2f/raw/ba51779474a150ee4367cda4f4ffacdcca479887/Products.json"
    
    func fetchAllProducts() -> AnyPublisher<[Product], Error> {
        guard let url = URL(string: baseURL) else { return Fail(error: CustomError.noConnection).eraseToAnyPublisher() }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: url)
        
        return dataTaskPublisher
            .map({ $0.data })
            .decode(type: ProductResponse.self, decoder: JSONDecoder())
            .map({ $0.products })
            .eraseToAnyPublisher()
    }
}
