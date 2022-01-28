//
//  MoviesListViewModelTests.swift
//  TheMovieDBTests
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import XCTest
@testable import TheMovieDB
import RxSwift

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

    func testMoviesListViewModel_WhenServiceFetchMovies_ShouldReturnMovies() throws {
        //Act
        let state = MoviesSpy(observable: sut.moviesObservable)
        sut.getLatestMovies()

        //Assert
        XCTAssertEqual(state.movies.count, 1, "Movies isn't fetched successfuly")
    }
    
    func testMoviesListViewModel_WhenServiceReturnError_ShouldNotReturnMovies() throws {
        //Act
        mockMoviesServices.shouldReturnError = true
        let state = MoviesSpy(observable: sut.moviesObservable)
        sut.getLatestMovies()

        //Assert
        XCTAssertEqual(state.movies.count, 0, "Movies fetched while error must be returned instead")
    }

    func testMoviesListViewModel_WhenServiceReturnError_ShouldReturnErrorMessage() throws {
        //Act
        mockMoviesServices.shouldReturnError = true
        let state = ErrorSpy(observable: sut.alertObservable)
        sut.getLatestMovies()

        //Assert
        XCTAssertEqual(state.error, "Error fetching movies", "Error message isn't displayed")
    }
    
    func testMoviesListViewModel_WhenServiceFetchMovies_ShouldNotReturnErrorMessage() throws {
        //Act
        mockMoviesServices.shouldReturnError = true
        let state = ErrorSpy(observable: sut.alertObservable)
        sut.getLatestMovies()

        //Assert
        XCTAssertEqual(state.error, "", "Error message displayed while movies should be fetched successfuly")
    }

    class MoviesSpy{
        private (set) var movies: [Movie] = []
        let disposeBag = DisposeBag()
        init(observable: Observable<[Movie]>){
            observable.subscribe(onNext: {[weak self] movies in
                guard let self = self else {return}
                self.movies = movies
            }).disposed(by: disposeBag)
        }
    }
    
    class ErrorSpy{
        private (set) var error: String = ""
        let disposeBag = DisposeBag()
        init(observable: Observable<String>){
            observable.subscribe(onNext: {[weak self] error in
                guard let self = self else {return}
                self.error = error
            }).disposed(by: disposeBag)
        }
    }

}
