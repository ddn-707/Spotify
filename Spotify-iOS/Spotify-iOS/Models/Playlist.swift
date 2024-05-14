//
//  Playlist.swift
//  Spotify-iOS
//
//  Created by DND on 12/04/2024.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let name: String
    let images: [APIImage]
    let owner: User
}
 
