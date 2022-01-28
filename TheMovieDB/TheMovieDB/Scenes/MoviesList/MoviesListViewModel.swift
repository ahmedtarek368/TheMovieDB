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
    
    private let moviesServices: MoviesServices!
    private let disposeBag: DisposeBag!
    
    init(moviesServices: MoviesServices = MoviesServices(), disposeBag: DisposeBag){
        self.moviesServices = moviesServices
        self.disposeBag = disposeBag
    }
    
    //MARK:- OUTPUT
    private var currentPage = BehaviorRelay<Int>(value: 1)
    private var maxPages = BehaviorRelay<Int>(value: 0)
    
    ///encapsulate data
    private var moviesBehavior = BehaviorRelay<[Movie]>(value: [])
    var moviesObservable: Observable<[Movie]>{
        return moviesBehavior.asObservable()
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
        moviesServices.getLatestMovies(page: page).subscribe(onNext: {[weak self] (result) in
            guard let self = self else {return}
            switch result{
            case .success(let response):
                if page == 1{
                    self.moviesBehavior.accept(response.results)
                }else{
                    let prevMovies = self.moviesBehavior.value
                    self.moviesBehavior.accept(prevMovies+response.results)
                }
                self.maxPages.accept(response.totalPages)
                self.currentPage.accept(response.page)
            case .failure(let error):
                self.alertSubject.onNext(error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
    
}
