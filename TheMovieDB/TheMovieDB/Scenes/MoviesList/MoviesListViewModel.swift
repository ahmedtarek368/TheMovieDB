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
    }
    
    //MARK:- OUTPUT
    ///encapsulate data
    private var currentPage = BehaviorRelay<Int>(value: 1)
    private var maxPages = BehaviorRelay<Int>(value: 0)
    
    private var moviesBehavior = BehaviorRelay<[Movie]>(value: [])
    lazy var moviesDriver: Driver<[Movie]> = moviesBehavior.asDriver(onErrorJustReturn: [])
    
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
