//
//  AuthManager.swift
//  Spotify-iOS
//
//  Created by DND on 12/04/2024.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private var refreshingToken = false
    
    struct Constants {
        static let clientID = "397ee46be88a48bbbbf2a533b8041b9b"
        static let clientSecret = "b48cca0da1344a6fa85678db5932e2be"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURL = "https://github.com/dinhdung140198/Spotify"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let stringURL = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURL)&show_dialog=TRUE"
        return URL(string: stringURL)
    }
    
    
    var inSignIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinute: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinute) >= expirationDate
    }
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping((Bool) -> Void)
    ) {
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURL)
        ]
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure get to base64")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result)
                print("Success:\(result)")
                completion(true)
                
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        
        task.resume()
    }
    
    private var onRefreshBlock = [((String) -> Void)]()
    
    public func withValidToken(completion: @escaping (String) -> Void){
        guard !refreshingToken else {
            //append the completion
            onRefreshBlock.append(completion)
            return
        }
        
        if shouldRefreshToken {
            //refresh token
            refreshIfNeed { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
            
    }
    
    public func refreshIfNeed(completion:((Bool) -> Void)?) {
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else  {
            return
        }
        
        //Refresh the token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
            URLQueryItem(name: "client_id", value: Constants.clientID)
        ]
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure get to base64")
            completion?(false)
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            
            do {
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result)
                print("Refresh token Successfully:\(result)")
                completion?(true)
                
            } catch {
                print(error.localizedDescription)
                completion?(false)
            }
        }
        
        task.resume()
    }
    
    private func cacheToken(_ result: AuthResponse){
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}
