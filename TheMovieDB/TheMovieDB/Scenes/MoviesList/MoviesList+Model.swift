//
//  MoviesList+Model.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import Foundation

protocol IsMovie {
    var id: Int {get}
    var originalTitle: String {get}
    var overview: String {get}
    var popularity: Double {get}
    var posterPath: String? {get}
    var releaseDate: String {get}
    var title: String {get}
    var voteAverage: Double {get}
    var voteCount: Int {get}
    var posterData: Data? {get}
}

// MARK: - MoviesResponse
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
struct Movie: Codable, IsMovie {
    let id: Int
    let originalTitle, overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate, title: String
    let voteAverage: Double
    let voteCount: Int
    let posterData: Data?
    
    enum CodingKeys: String, CodingKey {
        case id, posterData
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    static let factory = Factory.instance
    struct Factory {
        static let instance = Factory()
        
        func MockMovie() -> Movie{
            return Movie(id: -1, originalTitle: "", overview: "", popularity: 0, posterPath: nil, releaseDate: "", title: "", voteAverage: -1, voteCount: -1, posterData: nil)
        }
    }
}

extension Movie{
    init(copyFrom obj: MovieEntity){
        self.id = Int(obj.id)
        self.originalTitle = obj.title ?? ""
        self.overview = obj.overview ?? ""
        self.popularity = obj.popularity
        self.posterPath = nil
        self.releaseDate = obj.releaseDate ?? ""
        self.title = obj.title ?? ""
        self.voteAverage = obj.voteAverage
        self.voteCount = Int(obj.voteCount)
        self.posterData = obj.poster
    }
}
