//
//  MovieDetailsViewModelTests.swift
//  TheMovieDBTests
//
//  Created by Ahmed Tarek on 29/01/2022.
//

import XCTest
@testable import TheMovieDB
import RxSwift
import RxCocoa

class MovieDetailsViewModelTests: XCTestCase {

    var mockMovieDetailsServices: MockMovieDetailsServices!
    var disposeBag: DisposeBag!
    var sut: MovieDetailsViewModel!
    
    override func setUp() {
        //Arrange
        mockMovieDetailsServices = MockMovieDetailsServices()
        disposeBag = DisposeBag()
        sut = MovieDetailsViewModel(movieDetailsServices: mockMovieDetailsServices, disposeBag: disposeBag)
    }

    override func tearDown() {
        mockMovieDetailsServices = nil
        disposeBag = nil
        sut = nil
    }
    
    //MARK:- Service fetch movie details successfully
    ///when service fetch movie details, movie details mustn't be nil and error must be nil
    func testMovieDetailsViewModel_WhenServiceFetchMovieDetails_ShouldReturnMovieDetails() throws {
        //Act
        let state = MovieDetailsSpy(observable: sut.movieDetailsObservable)
        sut.getMovieDetails(id: 1)

        //Assert
        XCTAssertNotNil(state.movieDetails, "Error fetching movie details")
    }
    
    func testMovieDetailsViewModel_WhenServiceFetchMovieDetails_ShouldNotReturnError() throws {
        //Act
        let state = ErrorSpy(observable: sut.alertObservable)
        sut.getMovieDetails(id: 1)

        //Assert
        XCTAssertNil(state.error, "Error message displayed while movie details must be fetched successfully")
    }
    
    //MARK:- Service fail to fetch movie details
    ///when service fail to fetch movie details, movie details must be nil and error mustn't be nil
    func testMovieDetailsViewModel_WhenServiceFailToFetchMovieDetails_ShouldNotReturnMovieDetails() throws {
        //Act
        mockMovieDetailsServices.shouldReturnError = true
        let state = MovieDetailsSpy(observable: sut.movieDetailsObservable)
        sut.getMovieDetails(id: 1)

        //Assert
        XCTAssertNil(state.movieDetails, "Movie details fetched while service must be failing to fetch it")
    }
    
    func testMovieDetailsViewModel_WhenServiceFailToFetchMovieDetails_ShouldReturnError() throws {
        //Act
        mockMovieDetailsServices.shouldReturnError = true
        let state = ErrorSpy(observable: sut.alertObservable)
        sut.getMovieDetails(id: 1)

        //Assert
        XCTAssertEqual(state.error, "Error fetching movie details", "Error message isn't displayed")
    }
    
    //MARK:- Service fetch reviews successfully
    ///when service fetch reviews, reviews mustn't be empty and error must be nil
    func testMovieDetailsViewModel_WhenServiceFetchReviews_ShouldReturnReviews() throws {
        //Act
        let state = ReviewsSpy(driver: sut.reviewsDriver)
        sut.getMovieReviews(id: 1)

        //Assert
        XCTAssertGreaterThan(state.reviews.count, 0, "Error fetching reviews")
    }
    
    func testMovieDetailsViewModel_WhenServiceFetchReviews_ShouldNotReturnError() throws {
        //Act
        let state = ErrorSpy(observable: sut.alertObservable)
        sut.getMovieReviews(id: 1)

        //Assert
        XCTAssertNil(state.error, "Error message displayed while movie reviews must be fetched successfully")
    }

    //MARK:- Service fail to fetch reviews
    ///when service fail to fetch reviews, reviews must be empty and error mustn't be nil
    func testMovieDetailsViewModel_WhenServiceFailToFetchReviews_ShouldNotReturnReviews() throws {
        //Act
        mockMovieDetailsServices.shouldReturnError = true
        let state = ReviewsSpy(driver: sut.reviewsDriver)
        sut.getMovieReviews(id: 1)

        //Assert
        XCTAssertEqual(state.reviews.count, 0, "Reviews fetched while service must be failing to fetch it")
    }

    func testMovieDetailsViewModel_WhenServiceFailToFetchReviews_ShouldReturnError() throws {
        //Act
        mockMovieDetailsServices.shouldReturnError = true
        let state = ErrorSpy(observable: sut.alertObservable)
        sut.getMovieReviews(id: 1)

        //Assert
        XCTAssertEqual(state.error, "Error fetching movie reviews", "Error message isn't displayed")
    }
    
    class MovieDetailsSpy{
        private (set) var movieDetails: MovieDetails? = nil
        let disposeBag = DisposeBag()
        init(observable: Observable<MovieDetails>){
            observable.subscribe(onNext: {[weak self] movieDetails in
                guard let self = self else {return}
                self.movieDetails = movieDetails
            }).disposed(by: disposeBag)
        }
    }
    
    class ReviewsSpy{
        private (set) var reviews: [Review] = []
        let disposeBag = DisposeBag()
        init(driver: Driver<[Review]>){
            driver.asObservable().subscribe(onNext: {[weak self] reviews in
                guard let self = self else {return}
                self.reviews = reviews
            }).disposed(by: disposeBag)
        }
    }
    
    class ErrorSpy{
        private (set) var error: String? = nil
        let disposeBag = DisposeBag()
        init(observable: Observable<String>){
            observable.subscribe(onNext: {[weak self] error in
                guard let self = self else {return}
                self.error = error
            }).disposed(by: disposeBag)
        }
    }

}
