//
//  MovieDetailsNetworking.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 29/01/2022.
//

import Foundation
import Alamofire

enum MovieDetailsNetworking {
    case getMovieDetails(id: Int)
    case getMovieReviews(id: Int, page: Int)
}

extension MovieDetailsNetworking: TargetType {
    var baseURL: String {
        switch self {
        default:
            return "https://api.themoviedb.org/3/movie"
        }
    }
    
    var path: String {
        switch self {
        case .getMovieDetails(let id):
            return "/\(id)?api_key=\(apiKey)&language=en-US"
        case .getMovieReviews(let id, let page):
            return "/\(id)/reviews?api_key=\(apiKey)&language=en-US&page=\(page)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMovieDetails, .getMovieReviews:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getMovieDetails, .getMovieReviews:
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
