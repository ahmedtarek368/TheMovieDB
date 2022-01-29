//
//  MovieDetailsViewModel.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 29/01/2022.
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailsViewModel: AlertObservable{
    
    private let movieDetailsServices: MovieDetailsServicesProtocol!
    private let disposeBag: DisposeBag!
    private let mainGroup = DispatchGroup()
    
    init(movieDetailsServices: MovieDetailsServicesProtocol = MovieDetailsServices(), disposeBag: DisposeBag) {
        self.movieDetailsServices = movieDetailsServices
        self.disposeBag = disposeBag
    }
    
    ///This is used to show the view when data is completely fetched
    var mainViewHidden: Observable<Bool>{
        return Observable<Bool>.combineLatest(reviewsDriver.asObservable(), movieDetailsObservable) { _, _ in
            return false
        }
    }
    
    //MARK:- OUTPUT
    ///encapsulate data
    private var currentPage = BehaviorRelay<Int>(value: 1)
    private var maxPages = BehaviorRelay<Int>(value: 0)
    
    private var reviewsBehavior = BehaviorRelay<[Review]>(value: [])
    lazy var reviewsDriver: Driver<[Review]> = reviewsBehavior.asDriver(onErrorJustReturn: [])
    
    private var movieDetailsSubject = PublishSubject<MovieDetails>()
    var movieDetailsObservable: Observable<MovieDetails>{
        return movieDetailsSubject.asObservable()
    }
    
    private var alertSubject = PublishSubject<String>()
    var alertObservable: Observable<String>{
        return alertSubject
    }
    
    ///Gets next reviews page if exists
    func getNextReviewsPage() -> Int?{
        return currentPage.value < maxPages.value ? currentPage.value+1 : nil
    }
    
    //Get movie details with reviews
    func getMovieDetailsData(id: Int){
        LoadingManager.shared.showProgressView()
        
        mainGroup.enter()
        getMovieDetails(id: id, isSeprate: false)
        
        mainGroup.enter()
        getMovieReviews(id: id, isSeprate: false)
        
        mainGroup.notify(queue: .main) {
            LoadingManager.shared.hideProgressView()
        }
    }
    
    func getMovieDetails(id: Int, isSeprate: Bool = true){
        if isSeprate{
            LoadingManager.shared.showProgressView()
        }
        movieDetailsServices.getMovieDetails(id: id)
            .subscribe(onNext: {[weak self] (result) in
                guard let self = self else {return}
                if isSeprate{
                    LoadingManager.shared.hideProgressView()
                }else{
                    self.mainGroup.leave()
                }
                switch result{
                case .success(let response):
                    self.movieDetailsSubject.onNext(response)
                case .failure(let error):
                    self.alertSubject.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
    func getMovieReviews(by page: Int = 1, id: Int, isSeprate: Bool = true){
        if isSeprate{
            LoadingManager.shared.showProgressView()
        }
        movieDetailsServices.getMovieReviews(id: id, page: page).subscribe(onNext: {[weak self] (result) in
            guard let self = self else {return}
            if isSeprate{
                LoadingManager.shared.hideProgressView()
            }else{
                self.mainGroup.leave()
            }
            switch result{
            case .success(let response):
                if page == 1{
                    self.reviewsBehavior.accept(response.results)
                }else{
                    let prevReviews = self.reviewsBehavior.value
                    self.reviewsBehavior.accept(prevReviews+response.results)
                }
                self.maxPages.accept(response.totalPages)
                self.currentPage.accept(response.page)
            case .failure(let error):
                self.alertSubject.onNext(error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
    
}
