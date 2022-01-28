//
//  NetworkConstants.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import Foundation

let apiKey = "3e7ed4340ee87b1eae88e0e9c8f214a9"

struct Poster {
    private static let poster = "https://image.tmdb.org/t/p/"
    
    struct Size{
        static let w92 = "\(Poster.poster)w92"
        static let w154 = "\(Poster.poster)w154"
        static let w185 = "\(Poster.poster)w185"
        static let w342 = "\(Poster.poster)w342"
        static let w500 = "\(Poster.poster)w500"
        static let w780 = "\(Poster.poster)w780"
        static let original = "\(Poster.poster)original"
    }
}
