//
//  SearchResult.swift
//  Spotify-iOS
//
//  Created by DND on 21/05/2024.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
