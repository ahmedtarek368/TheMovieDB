//
//  MockMoviesServices.swift
//  TheMovieDBTests
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import Foundation
@testable import TheMovieDB
import RxSwift

class MockMoviesServices: MoviesServicesProtocol{
    
    var shouldReturnError: Bool = false

    func getLatestMovies(page: Int) -> Observable<Result<MoviesResponse, NSError>> {
        return Observable.create { observer in
            if self.shouldReturnError{
                let error = NSError(domain: "https://image.tmdb.org", code: -1, userInfo: [NSLocalizedDescriptionKey: MockErrorMessage.genericError.rawValue])
                observer.onNext(.failure(error))
            }else{
                observer.onNext(.success(MoviesResponse.factory.DefaultResponse()))
            }
            return Disposables.create()
        }
    }
}

