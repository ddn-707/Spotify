//
//  PlaylistDetailsReponse.swift
//  Spotify-iOS
//
//  Created by DND on 28/05/2024.
//

import Foundation

struct PlaylistDetailsReponse: Codable {
    let description: String
    let external_urls: [String:String]
    let id: String
    let images: [APIImage]
    let name: String
    let tracks: PlaylistTrackReponse
}

struct PlaylistTrackReponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let track: AudioTrack
}
