//
//  MoviesServices.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import Foundation
import RxSwift

protocol MoviesServicesProtocol {
    func getLatestMovies(page: Int) -> Observable<Result<MoviesResponse, NSError>>
}


class MoviesServices: APIClient<MoviesNetworking>, MoviesServicesProtocol {
    //MARK:- Requests

    func getLatestMovies(page: Int) -> Observable<Result<MoviesResponse, NSError>> {
        return self.fetchData(target: .getLatestMovies(page: page))
    }
}
