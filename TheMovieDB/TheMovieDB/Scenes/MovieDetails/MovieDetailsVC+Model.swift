//
//  MovieDetailsVC+Model.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 29/01/2022.
//

import Foundation

// MARK: - MovieDetails
struct MovieDetails: Codable, IsMovie {
    
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdbID: String?
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let revenue, runtime: Int
    let spokenLanguages: [SpokenLanguage]
    let status, tagline, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    var posterData: Data?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    static let factory = Factory.instance
    struct Factory {
        static let instance = Factory()
        
        func MockMovieDetailsResponse() -> MovieDetails{
            return MovieDetails(adult: false, backdropPath: nil, belongsToCollection: nil, budget: -1, genres: [], homepage: "", id: -1, imdbID: nil, originalLanguage: "", originalTitle: "", overview: "", popularity: -1, posterPath: nil, productionCompanies: [], productionCountries: [], releaseDate: "", revenue: -1, runtime: -1, spokenLanguages: [], status: "", tagline: "", title: "", video: false, voteAverage: -1, voteCount: -1)
        }
    }
}

// MARK: - BelongsToCollection
struct BelongsToCollection: Codable {
    let id: Int
    let name: String
    let posterPath, backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name, originCountry: String

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1, name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

// MARK: - ReviewsResponse
struct ReviewsResponse: Codable {
    let id, page: Int
    let results: [Review]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    static let factory = Factory.instance
    struct Factory {
        static let instance = Factory()
        
        func MockReviewsResponse() -> ReviewsResponse{
            return ReviewsResponse(id: -1, page: -1, results: [Review.factory.MockReview()], totalPages: -1, totalResults: -1)
        }
    }
}

// MARK: - Review
struct Review: Codable {
    let author: String
    let authorDetails: AuthorDetails
    let content, createdAt, id, updatedAt: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
    
    static let factory = Factory.instance
    struct Factory {
        static let instance = Factory()
        
        func MockReview() -> Review{
            return Review(author: "", authorDetails: AuthorDetails.factory.MockAuthorDetails(), content: "", createdAt: "", id: "", updatedAt: "", url: "")
        }
    }
}

// MARK: - AuthorDetails
struct AuthorDetails: Codable {
    let name, username: String
    let avatarPath: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }
    
    static let factory = Factory.instance
    struct Factory {
        static let instance = Factory()
        
        func MockAuthorDetails() -> AuthorDetails{
            return AuthorDetails(name: "", username: "", avatarPath: nil, rating: nil)
        }
    }
}
