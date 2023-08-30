//
//  Photo.swift
//  Swift-Flickr
//



import Foundation

// MARK: - Welcome
struct Photo: Codable {
    let id, owner, server: String?
    let farm: Int?
    let title: String?
    let description: Description?
    let ownername, iconserver: String?
    let iconfarm: Int?
    let urlN: String?
    let urlZ: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id, owner, server, farm, title
        case description = "description"
        case ownername, iconserver, iconfarm
        case urlN = "url_n"
        case urlZ = "url_z"
     
    }
}

// MARK: - Description
struct Description: Codable {
    let content: String?

    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}
