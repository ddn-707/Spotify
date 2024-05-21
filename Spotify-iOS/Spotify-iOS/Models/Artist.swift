//
//  Artist.swift
//  Spotify-iOS
//
//  Created by DND on 12/04/2024.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
}
