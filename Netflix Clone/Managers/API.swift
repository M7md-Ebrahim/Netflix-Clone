//
//  API.swift
//  Netflix
//
//  Created by M7md  on 25/04/2024.
//


import Foundation

enum APIError: Error {
    case failedTogetData
}
class API {
    static let shared = API()

    func getTrendingMovies (complation: @escaping(Result<[Movie], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.apiKey)") else {return}
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {return}
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                complation(.success(response.results))
            } catch {
                complation(.failure(APIError.failedTogetData))
            }
        }
        .resume()
    }
    func getTrendingTVs (complation: @escaping(Result<[Movie], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.apiKey)") else {return}
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {return}
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                complation(.success(response.results))
            } catch {
                complation(.failure(APIError.failedTogetData))
            }
        }
        .resume()
    }
    func getPopular (complation: @escaping(Result<[Movie], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.apiKey)&language=en-US&page=1") else {return}
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {return}
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                complation(.success(response.results))
            } catch {
                complation(.failure(APIError.failedTogetData))
            }
        }
        .resume()
    }
    func getUpcomingMovies (complation: @escaping(Result<[Movie], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.apiKey)&language=en-US&page=1") else {return}
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {return}
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                complation(.success(response.results))
            } catch {
                complation(.failure(APIError.failedTogetData))
            }
        }
        .resume()
    }
    func getTopRated (complation: @escaping(Result<[Movie], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.apiKey)&language=en-US&page=1") else {return}
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {return}
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                complation(.success(response.results))
            } catch {
                complation(.failure(APIError.failedTogetData))
            }
        }
        .resume()
    }
    func getDiscover (complation: @escaping (Result<[Movie], APIError>) -> Void) {
        let trailing = "&include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_watch_monetization_types=flatrate"
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.apiKey)\(trailing)") else {return}
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {return}
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                complation(.success(response.results))
            } catch {
                complation(.failure(APIError.failedTogetData))
            }
        }
        .resume()
    }
    func getQuery (_ query: String, complation: @escaping (Result<[Movie], APIError>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.apiKey)&query=\(query)") else {
            return}
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {return}
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                complation(.success(response.results))
            } catch {
                complation(.failure(APIError.failedTogetData))
            }
        }
        .resume()
    }
    func getMovie (_ query: String, complation: @escaping (Result<YouTubeItem, APIError>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return}
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)trailer&key=\(Constants.youtubeAPIK)") else {
            return}
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {return}
            do {
                let response = try JSONDecoder().decode(YoutubeResponse.self, from: data)
                complation(.success(response.items[0]))
            } catch {
                complation(.failure(APIError.failedTogetData))
            }
        }
        .resume()
    }
}
