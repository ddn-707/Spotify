//
//  FeaturePlaylistReponse.swift
//  Spotify-iOS
//
//  Created by DND on 29/04/2024.
//

import Foundation

struct FeaturePlaylistReponse: Codable {
    let playlists: PlaylistReponse
}

struct PlaylistReponse: Codable {
    let items: [Playlist]
}

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let name: String
    let images: [APIImage]
    let owner: User
}

struct User: Codable {
    let id: String
    let external_urls: [String: String]
    let display_name: String
}
