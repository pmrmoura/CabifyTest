//
//  DiscountService.swift
//  CabifyTest
//
//  Created by Pedro Moura on 08/02/23.
//

import Foundation

final class DiscountService {
    static var baseURL = "https://gist.githubusercontent.com/pmrmoura/83a724e28ec78cac9ea930068681c78b/raw/888ca2f3026916bd08c8057d7ae2f0f2f420a4dd/Discounts.json"
    
    static func getAllDiscounts(completion: @escaping (Result<[Discount], Error>) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(#function, "🧨 Request: \(request)\nError: \(error)")
                return
            }
            
            guard let data = data else {
                completion(.failure(CustomError.noData))
                return
            }
            
            do {
                let discounts = try JSONDecoder().decode(DiscountResponse.self, from: data)
                completion(.success(discounts.discounts))
            } catch let error {
                print(#function, "🧨 Request: \(request)\nError: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}

