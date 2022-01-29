//
//  MoviesList+Model.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import Foundation

// MARK: - Welcome
struct MoviesResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    static let factory = Factory.instance
    struct Factory {
        static let instance = Factory()
        
        func MockMoviesResponse() -> MoviesResponse{
            return MoviesResponse(page: -1, results: [Movie.factory.MockMovie()], totalPages: -1, totalResults: -1)
        }
    }
}

// MARK: - Result
struct Movie: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle, overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    static let factory = Factory.instance
    struct Factory {
        static let instance = Factory()
        
        func MockMovie() -> Movie{
            return Movie(adult: false, backdropPath: nil, genreIDS: [], id: -1, originalLanguage: "", originalTitle: "", overview: "", popularity: 0, posterPath: nil, releaseDate: "", title: "", video: false, voteAverage: -1, voteCount: -1)
        }
    }
}

