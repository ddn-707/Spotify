//
//  APICaller.swift
//  Spotify-iOS
//
//  Created by DND on 12/04/2024.
//

import Foundation

class APICaller {
    static let shared = APICaller()
    
    private init(){}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case faileedToGetData
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile,Error>) -> Void){
        
        createRequest(with: URL(string: Constants.baseAPIURL + "/me"), type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data ,error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                    print(result)
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
        
    }
    
    public func getNewReleases (completion: @escaping((Result<NewReleasesResponse,Error>) -> Void)){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    public func getFeaturePlaylist (completion: @escaping((Result<FeaturePlaylistReponse,Error>)-> Void)) {
        createRequest(with: URL(string:  Constants.baseAPIURL + "/browse/featured-playlists?limit=20"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(FeaturePlaylistReponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    public func getRecommendations(genres: Set<String>,completion: @escaping ((Result<RecommendationsResponse,Error>) -> Void)){
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?limit=20&seed_genres=\(seeds)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    //MARK: - get Recommended Genres
    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenresResponse,Error>) -> Void)){
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Get categories
    
    public func getCategories(completion:@escaping((Result<[Category],Error>)-> Void)){
        let urlString = Constants.baseAPIURL + "/browse/categories?limt=50"
        print(urlString)
        createRequest(with: URL(string: urlString), type: .GET) {
            request in
            let task = URLSession.shared.dataTask(with: request) {
                data, _, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(CategoriesResponse.self, from: data)
                    //                    JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    completion(.success(result.categories.items))
                    print("get categories Success: \(result)")
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Search
    public func search (with query: String, completion:@escaping((Result<[SearchResult],Error>)->Void)){
        let stringURL = Constants.baseAPIURL + "/search?limit=15&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        print("String url : \(stringURL)")
        createRequest(
            with: URL(string: stringURL),
            type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.faileedToGetData))
                        return
                    }
                    
                    do {
                        let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                        var searchResults: [SearchResult] = []
                        searchResults.append(
                            contentsOf: result.artists.items.compactMap({
                                SearchResult.artist(model: $0)
                            })
                        )
                        
                        searchResults.append(
                            contentsOf: result.albums.items.compactMap({
                                SearchResult.album(model: $0)
                            })
                        )
                        
                        searchResults.append(
                            contentsOf: result.tracks.items.compactMap({
                                SearchResult.track(model: $0)
                            })
                        )
                        
                        searchResults.append(
                            contentsOf: result.playlists.items.compactMap({
                                SearchResult.playlist(model: $0)
                            })
                        )
                        completion(.success(searchResults))
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    //MARK: - private
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    private func createRequest( with url: URL?, type: HTTPMethod, completion: @escaping(URLRequest) -> Void){
        
        AuthManager.shared.withValidToken { token in
            NSLog(" access token \(token)")
            guard let apiURL = url else {
                return
            }
            
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
