//
//  ChannelsListViewModel.swift
//  DemoAssignment
//
//  Created by IA on 08/09/24.
//

import Foundation

struct ChannelsListViewModel {
    
    private let authResource = AuthResource()
    private let channelListResource = ChannelsListResource()
    
    func getChannelsList(email: String, pwd: String) async throws -> [Channels]? {
        do {
            let authResponse = try await authResource.getToken(email: email, pwd: pwd)
            saveToken(token: authResponse.token)
            return try await channelListResource.getChannelsList(token: authResponse.token)
        } catch let serviceError {
            throw serviceError
        }
    }
    
    func saveToken(token: String) {
        let keyToken = "keyToken"
        let tokenDataValue = token.data(using: .utf8) ?? Data()
        let isSaved = KeychainService.save(data: tokenDataValue, forKey: keyToken)
        //        print("token isSaved: \(isSaved)")
    }
}
