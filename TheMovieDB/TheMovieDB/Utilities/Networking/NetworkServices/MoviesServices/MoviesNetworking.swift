//
//  MoviesNetworking.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import Foundation
import Alamofire

enum MoviesNetworking {
    case getLatestMovies(page: Int)
}

extension MoviesNetworking: TargetType {
    var baseURL: String {
        switch self {
        default:
            return "https://api.themoviedb.org/3/movie"
        }
    }
    
    var path: String {
        switch self {
        case .getLatestMovies(let page):
            return "/now_playing?api_key=\(apiKey)&language=en-US&page=\(page)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getLatestMovies:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getLatestMovies:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
}
