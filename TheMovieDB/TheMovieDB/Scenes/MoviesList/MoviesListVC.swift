//
//  MoviesListVC.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import UIKit
import RxSwift

class MoviesListVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var moviesCV: UICollectionView!
    
    //MARK:- Variables
    private var viewModel: MoviesListViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewWillLayoutSubviews() {
        resizeCells()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MoviesListViewModel(disposeBag: disposeBag)
        subscribeToAlert(viewModel: viewModel, disposeBag: disposeBag)
        registerCell()
        bindMoviesListToMoviesCV()
        subscribeToDidEndDecelerating()
        getLatestMovies()
    }
    
    private func registerCell(){
        moviesCV.registerNib(cell: MovieCell.self)
    }
    
    private func resizeCells(){
        let newWidth = (moviesCV.bounds.width-2)/2
        if UIDevice().userInterfaceIdiom == .phone{
            moviesCV.resizeItem(width: newWidth, height: newWidth * 1.5)
        }else{
            
        }
    }
    
    ///Gets first page when i first enter or when i refresh movies
    private func getLatestMovies(){
        viewModel.getLatestMovies()
    }
    
    ///Bind the movies list from viewModel to movies CV
    ///Observing movies is on main thread
    private func bindMoviesListToMoviesCV(){
        viewModel.moviesObservable
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
            .drive(moviesCV.rx.items(cellIdentifier: "MovieCell", cellType: MovieCell.self)){(row, movie, cell) in
                cell.setData(poster: movie.posterPath, name: movie.title)
        }.disposed(by: disposeBag)
    }
    
    ///Take action when scrolling comes to an end to fetch new page content
    private func subscribeToDidEndDecelerating(){
        moviesCV.rx.didEndDecelerating.subscribe(onNext: {[unowned self] _ in
            if self.moviesCV.isNearBottomEdge(){
                if let page = self.viewModel.getNextLatestMoviesPage(){
                    self.viewModel.getLatestMovies(by: page)
                }
            }
        }).disposed(by: disposeBag)
    }

}