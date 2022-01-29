//
//  MockMovieDetailsServices.swift
//  TheMovieDBTests
//
//  Created by Ahmed Tarek on 29/01/2022.
//

import Foundation
@testable import TheMovieDB
import RxSwift

class MockMovieDetailsServices: MovieDetailsServicesProtocol{
    
    var shouldReturnError: Bool = false

    func getMovieDetails(id: Int) -> Observable<Result<MovieDetails, NSError>> {
        return Observable.create { observer in
            if self.shouldReturnError{
                let error = NSError(domain: "https://image.tmdb.org", code: -1, userInfo: [NSLocalizedDescriptionKey: MockErrorMessage.movieDetailsError.rawValue])
                observer.onNext(.failure(error))
            }else{
                observer.onNext(.success(MovieDetails.factory.MockMovieDetailsResponse()))
            }
            return Disposables.create()
        }
    }
    
    func getMovieReviews(id: Int, page: Int) -> Observable<Result<ReviewsResponse, NSError>> {
        return Observable.create { observer in
            if self.shouldReturnError{
                let error = NSError(domain: "https://image.tmdb.org", code: -1, userInfo: [NSLocalizedDescriptionKey: MockErrorMessage.movieReviewsError.rawValue])
                observer.onNext(.failure(error))
            }else{
                observer.onNext(.success(ReviewsResponse.factory.MockReviewsResponse()))
            }
            return Disposables.create()
        }
    }
    
}
