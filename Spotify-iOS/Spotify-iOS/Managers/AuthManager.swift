//
//  AuthManager.swift
//  Spotify-iOS
//
//  Created by DND on 12/04/2024.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private init(){}
    
    var inSignIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false  
    }
}
