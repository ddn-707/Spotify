//
//  AuthManager.swift
//  Spotify-iOS
//
//  Created by DND on 12/04/2024.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
        static let clientID = "89dbf3cb80c649b38d571f71f2d11a04"
        static let clientSecret = "0fe080b30a9640169bf10516b71a0de7"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURL = "https://github.com/nguyenht65/Spotify"
        static let scopes = "user-read-private%20user-read-email%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let stringURL = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURL)&show_dialog=TRUE"
        return URL(string: stringURL)
    }
    
    
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
