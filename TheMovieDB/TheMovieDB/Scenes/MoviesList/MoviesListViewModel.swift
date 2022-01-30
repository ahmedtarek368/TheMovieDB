//
//  MoviesListViewModel.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import Foundation
import RxSwift
import RxCocoa

class MoviesListViewModel: AlertObservable{
    
    private let moviesServices: MoviesServicesProtocol!
    private let disposeBag: DisposeBag!
    
    init(moviesServices: MoviesServicesProtocol = MoviesServices(), disposeBag: DisposeBag){
        self.moviesServices = moviesServices
        self.disposeBag = disposeBag
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMoviesList), name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
    
    //MARK:- OUTPUT
    ///encapsulate data
    private var currentPage = BehaviorRelay<Int>(value: 1)
    private var maxPages = BehaviorRelay<Int>(value: 0)
    private var movies = BehaviorRelay<[Movie]>(value: [])
    
    var favFilter = BehaviorRelay<Bool>(value: false)
    var searchStr = BehaviorRelay<String>(value: "")
    ///Used to search the movies with provided string
    var filteredMovies: Observable<[Movie]>{
        return Observable.combineLatest(movies.asObservable(), searchStr, favFilter.asObservable()){(movies, searchString, favFilter) in
            let movies = searchString == "" ?
                movies : movies.filter {$0.title.contains(searchString)}
            return favFilter ? movies.filter {CDS.instance.isMovieExist(id: $0.id)} : movies
        }
    }
    
    private var alertSubject = PublishSubject<String>()
    var alertObservable: Observable<String>{
        return alertSubject
    }
    
    ///Gets next page if exists
    func getNextLatestMoviesPage() -> Int?{
        return currentPage.value < maxPages.value ? currentPage.value+1 : nil
    }
    
    func getLatestMovies(by page: Int = 1){
        LoadingManager.shared.showProgressView()
        moviesServices.getLatestMovies(page: page)
            .subscribe(onNext: {[weak self] (result) in
            guard let self = self else {return}
            LoadingManager.shared.hideProgressView()
            switch result{
            case .success(let response):
                if page == 1{
                    self.movies.accept(response.results)
                }else{
                    let prevMovies = self.movies.value
                    self.movies.accept(prevMovies+response.results)
                }
                self.maxPages.accept(response.totalPages)
                self.currentPage.accept(response.page)
            case .failure(let error):
                self.alertSubject.onNext(error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
 
    @objc private func refreshMoviesList(){
        movies.accept(movies.value)
    }
    
}
