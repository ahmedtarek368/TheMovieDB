//
//  MovieDetailsServices.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 29/01/2022.
//

import Foundation
import RxSwift

protocol MovieDetailsServicesProtocol {
    func getMovieDetails(id: Int) -> Observable<Result<MovieDetails, NSError>>
    func getMovieReviews(id: Int, page: Int) -> Observable<Result<ReviewsResponse, NSError>>
}


class MovieDetailsServices: APIClient<MovieDetailsNetworking>, MovieDetailsServicesProtocol {
    
    //MARK:- Requests
    
    func getMovieDetails(id: Int) -> Observable<Result<MovieDetails, NSError>> {
        return self.fetchData(target: .getMovieDetails(id: id))
    }
    
    func getMovieReviews(id: Int, page: Int) -> Observable<Result<ReviewsResponse, NSError>> {
        return self.fetchData(target: .getMovieReviews(id: id, page: page))
    }
}
