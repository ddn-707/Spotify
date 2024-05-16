//
//  CategoriesResponse.swift
//  Spotify-iOS
//
//  Created by DND on 16/05/2024.
//

import Foundation

struct CategoriesResponse: Codable {
    let categories : Categories
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImage]
}
