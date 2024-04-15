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
        static let clientID = "397ee46be88a48bbbbf2a533b8041b9b"
        static let clientSecret = "b48cca0da1344a6fa85678db5932e2be"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let redirectURL = "https://github.com/dinhdung140198/Spotify"
        let scopes = "user-read-private"
        let stringURL = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURL)&show_dialog=TRUE"
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
    
    public func exchangeCodeForToken(
        code: String,
        complete: @escaping((Bool) -> Void)
    ) {
        
    }
    
//    public func refreshToken(){
//        
//    }
//    
//    private func cacheToken(){
//        
//    }
}
