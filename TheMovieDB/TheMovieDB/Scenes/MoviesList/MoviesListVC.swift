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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.darkTranslucent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MoviesListViewModel(disposeBag: disposeBag)
        subscribeToAlert(viewModel: viewModel, disposeBag: disposeBag)
        registerCell()
        bindMoviesListToMoviesCV()
        subscribeToDidEndDecelerating()
        subscribeToMovieSelection()
        getLatestMovies()
    }
    
    private func registerCell(){
        moviesCV.registerNib(cell: MovieCell.self)
    }
    
    private func resizeCells(){
        if UIDevice().userInterfaceIdiom == .phone{
            let newWidth = (moviesCV.bounds.width-3)/2
            moviesCV.resizeItem(width: newWidth, height: newWidth * 1.5)
        }else{
            let newWidth = (moviesCV.bounds.width-8)/3
            moviesCV.resizeItem(width: newWidth, height: newWidth * 1.5)
        }
    }
    
    ///Gets first page when i first enter or when i refresh movies
    private func getLatestMovies(){
        viewModel.getLatestMovies()
    }
    
    ///Bind the movies list from viewModel to movies CV
    ///Drive is called on main thread
    private func bindMoviesListToMoviesCV(){
        viewModel.moviesDriver.drive(moviesCV.rx.items(cellIdentifier: "MovieCell", cellType: MovieCell.self)){(row, movie, cell) in
                cell.setData(poster: movie.posterPath, name: movie.title)
        }.disposed(by: disposeBag)
    }
    
    ///Item selection event zipped with model selected
    private func subscribeToMovieSelection(){
        Observable.zip(moviesCV.rx.itemSelected, moviesCV.rx.modelSelected(Movie.self)).subscribe(onNext: {[unowned self] (indexPath, movie) in
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsVC") as! MovieDetailsVC
            VC.movieId = movie.id
            self.navigationController?.pushViewController(VC, animated: true)
        }).disposed(by: disposeBag)
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
