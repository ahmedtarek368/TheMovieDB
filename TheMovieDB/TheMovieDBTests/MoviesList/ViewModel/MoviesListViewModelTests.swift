//
//  MoviesListViewModelTests.swift
//  TheMovieDBTests
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import XCTest
@testable import TheMovieDB
import RxSwift
import RxCocoa

class MoviesListViewModelTests: XCTestCase {

    var mockMoviesServices: MockMoviesServices!
    var disposeBag: DisposeBag!
    var sut: MoviesListViewModel!
    
    override func setUp() {
        //Arrange
        mockMoviesServices = MockMoviesServices()
        disposeBag = DisposeBag()
        sut = MoviesListViewModel(moviesServices: mockMoviesServices, disposeBag: disposeBag)
    }

    override func tearDown() {
        mockMoviesServices = nil
        disposeBag = nil
        sut = nil
    }

    //MARK:- Service fetch movies successfully
    ///when service fetch movies, movies mustn't be empty and error must be nil
    func testMoviesListViewModel_WhenServiceFetchMovies_ShouldReturnMovies() throws {
        //Act
        let state = MoviesSpy(driver: sut.moviesDriver)
        sut.getLatestMovies()

        //Assert
        XCTAssertGreaterThan(state.movies.count, 0, "Movies isn't fetched successfully")
    }
    
    func testMoviesListViewModel_WhenServiceFetchMovies_ShouldNotReturnErrorMessage() throws {
        //Act
        let state = ErrorSpy(observable: sut.alertObservable)
        sut.getLatestMovies()
        
        //Assert
        XCTAssertNil(state.error, "Error message displayed while movies must be fetched successfully")
    }
    
    //MARK:- Service fail to fetch movies
    ///when service fail to fetch movies, movies must be empty and error mustn't be nil
    func testMoviesListViewModel_WhenServiceFailToFetchMovies_ShouldNotReturnMovies() throws {
        //Act
        mockMoviesServices.shouldReturnError = true
        let state = MoviesSpy(driver: sut.moviesDriver)
        sut.getLatestMovies()

        //Assert
        XCTAssertEqual(state.movies.count, 0, "Movies fetched while service must be failing to fetch it")
    }

    func testMoviesListViewModel_WhenServiceFailToFetchMovies_ShouldReturnErrorMessage() throws {
        //Act
        mockMoviesServices.shouldReturnError = true
        let state = ErrorSpy(observable: sut.alertObservable)
        sut.getLatestMovies()

        //Assert
        XCTAssertEqual(state.error, "Error fetching movies", "Error message isn't displayed")
    }
    

    class MoviesSpy{
        private (set) var movies: [Movie] = []
        let disposeBag = DisposeBag()
        init(driver: Driver<[Movie]>){
            driver.asObservable().subscribe(onNext: {[weak self] movies in
                guard let self = self else {return}
                self.movies = movies
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
