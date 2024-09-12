//
//  APIService.swift
//  DemoAssignment
//
//  Created by IA on 08/09/24.
//

import Foundation
// MARK: - we can safely unwrapped below
struct APIService {
    static let tokenURL: URL = URL(string: "https://\(host)/teamchatapi/iwauthentication.login.plain")!
    static let channelsListURL: URL = URL(string: "https://\(host)/teamchatapi/channels.list")!
}
