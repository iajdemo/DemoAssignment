//
//  HTTPUtility.swift
//  DemoAssignment
//
//  Created by IA on 08/09/24.
//

import Foundation

enum httpError: Error {
    case jsonDecoding
    case noData
    case nonSuccessStatusCode
    case serverError
    case emptyCollection
    case emptyObject
}

final class HTTPUtility {
    
    static let shared: HTTPUtility = HTTPUtility()
    private init() {}
    
    func performOperation<T :Decodable>(request: URLRequest, response: T.Type) async throws -> T {
        
        do {
            let (serverData, serverUrlResponse) = try await URLSession.shared.data(for: request)
            guard let httpStausCode = (serverUrlResponse as? HTTPURLResponse)?.statusCode,
                  (200...299).contains(httpStausCode) else {
                throw httpError.nonSuccessStatusCode
            }
            let response = try JSONDecoder().decode(response.self, from: serverData)
            return response
        } catch  {
            throw error
        }
    }
}
