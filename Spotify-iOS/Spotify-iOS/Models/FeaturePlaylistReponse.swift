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

struct User: Codable {
    let id: String
    let external_urls: [String: String]
    let display_name: String
}
