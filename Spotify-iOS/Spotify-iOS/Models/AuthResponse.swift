//
//  AuthResponse.swift
//  Spotify-iOS
//
//  Created by DND on 18/04/2024.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String
    let scope: String
    let token_type: String
}
