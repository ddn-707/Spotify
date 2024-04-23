//
//  SettingModels.swift
//  Spotify-iOS
//
//  Created by DND on 22/04/2024.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
