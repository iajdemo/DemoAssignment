//
//  ChannelsListResource.swift
//  DemoAssignment
//
//  Created by IA on 08/09/24.
//

import Foundation

struct ChannelsListResource {
    
    func getChannelsList(token: String) async throws -> [Channels] {
        var urlRequest = URLRequest(url: APIService.channelsListURL)
        urlRequest.httpMethod = "post"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = createChannelsListHTTPBody(serviceToken: token)
        //        urlRequest.debug()
        do {
            let response = try await HTTPUtility.shared.performOperation(request: urlRequest, response: ChannelsListResponse.self)
            guard let unwrappedChannels = response.channels else {
                return []
            }
            return unwrappedChannels
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }
    
    private func createChannelsListHTTPBody(serviceToken: String) -> Data? {
        let channelsListBody: Data = "token=\(serviceToken)&include_unread_count=\(includeUnreadCount)&exclude_members=\(excludeMembers)&include_permissions=\(includePermissions)".data(using: .utf8) ?? Data()
        return channelsListBody
    }
}
