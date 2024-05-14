//
//  RecommendationsResponse.swift
//  Spotify-iOS
//
//  Created by DND on 01/05/2024.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}
