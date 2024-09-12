//
//  AuthResource.swift
//  DemoAssignment
//
//  Created by IA on 08/09/24.
//

import Foundation

struct AuthResource {
    
    func getToken(email: String, pwd: String) async throws -> AuthResponse {
        var urlRequest = URLRequest(url: APIService.tokenURL)
        urlRequest.httpMethod = "post"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = createAuthHTTPBody(email: email, pwd: pwd)
        //        urlRequest.debug()
        do {
            let response = try await HTTPUtility.shared.performOperation(request: urlRequest, response: AuthResponse.self)
            return response
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }
    
    private func createAuthHTTPBody(email: String, pwd: String) -> Data {
        let authBody: Data = "username=\(email)&password=\(pwd)".data(using: .utf8) ?? Data()
        return authBody
    }
}
