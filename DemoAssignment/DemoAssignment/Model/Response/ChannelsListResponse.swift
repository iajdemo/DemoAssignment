//
//  ChannelsListResponse.swift
//  DemoAssignment
//
//  Created by IA on 08/09/24.
//

import Foundation

struct Section {
    let title : String
    let channels : [Channels]
}

struct ChannelsListResponse: Decodable {
    let ok : Bool?
    let channels : [Channels]?
}

struct Channels: Decodable {
    let id : String?
    let name : String?
    let created : Int?
    let creator : String?
    let is_archived : Bool?
    let is_member : Bool?
    let group_email : String?
    let group_folder_name : String?
    let is_active : Bool?
    let is_auto_followed : Bool?
    let is_notifications : Bool?
    let last_seen : String?
    let latest : Int?
    let unread_count : Int?
    let thread_unread_count : Int?
    let members : [String]?
    let permissions : Permissions?
}

struct Permissions : Codable {
    let items_read : Bool?
    let items_write : Bool?
    let items_modify : Bool?
    let items_delete : Bool?
    let items_edit_documents : Bool?
    let folder_read : Bool?
    let folder_write : Bool?
    let folder_rename : Bool?
    let folder_delete : Bool?
    let administration_invite : Bool?
    let administration_kick : Bool?
    let administration_administer : Bool?
}
