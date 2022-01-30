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
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var moviesCV: UICollectionView!
    @IBOutlet private weak var favoriteFilterBtn: UIBarButtonItem!
    
    //MARK:- Variables
    private var viewModel: MoviesListViewModel!
    private let disposeBag = DisposeBag()
    var refreshControl: UIRefreshControl?
    
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
        addRefreshControl()
        view.hideKeyBoardWhenTappedAround()
        bindMoviesListToMoviesCV()
        subscribeToDidEndDecelerating()
        subscribeToMovieSelection()
        subscribeToFavoriteFilterBtn()
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
    
    func addRefreshControl(){
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
        refreshControl?.addTarget(self, action: #selector(refreshMoviesList(sender:)), for: .valueChanged)
        moviesCV.addSubview(refreshControl!)
        viewModel.filteredMovies.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.refreshControl?.endRefreshing()
        }).disposed(by: disposeBag)
    }
    @objc func refreshMoviesList(sender: UIRefreshControl){
        viewModel.getLatestMovies()
    }
    
    ///Gets first page when i first enter or when i refresh movies
    private func getLatestMovies(){
        viewModel.getLatestMovies()
    }
    
    ///Bind the movies list from viewModel to movies CV
    ///Drive is called on main thread
    private func bindMoviesListToMoviesCV(){
        viewModel.filteredMovies.asDriver(onErrorJustReturn: []).drive(moviesCV.rx.items(cellIdentifier: "MovieCell", cellType: MovieCell.self)){(row, movie, cell) in
            cell.setData(poster: movie.posterPath, name: movie.title)
            cell.checkFavorite(isFavorite: CDS.instance.isMovieExist(id: movie.id))
            subscribeToFavoriteBtnTapAction(cell: cell, movie: movie)
        }.disposed(by: disposeBag)
        
        ///favorite btn tap action
        func subscribeToFavoriteBtnTapAction(cell: MovieCell, movie: Movie){
            cell.favoriteBtn.rx.tap.subscribe(onNext: { _ in
                if cell.isFavorite{
                    CDS.instance.delete(id: movie.id)
                }else{
                    CDS.instance.save(movie: movie, posterData: cell.getPosterData())
                }
            }).disposed(by: cell.disposeBag)
        }
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
            if self.moviesCV.isNearBottomEdge() && self.viewModel.favFilter.value == false{
                if let page = self.viewModel.getNextLatestMoviesPage(){
                    self.viewModel.getLatestMovies(by: page)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func subscribeToFavoriteFilterBtn(){
        favoriteFilterBtn.rx.tap.subscribe(onNext: {[unowned self] _ in
            if self.viewModel.favFilter.value{
                self.viewModel.favFilter.accept(false)
                self.favoriteFilterBtn.image = UIImage(named: "heart_border")
            }else{
                self.viewModel.favFilter.accept(true)
                self.favoriteFilterBtn.image = UIImage(named: "heart_fill")
            }
        }).disposed(by: disposeBag)
    }

    @IBAction func searchBtnTapped(_ sender: Any) {
        if self.searchBar.isHidden == true{
            UIView.animate(withDuration: 0.3) {
                self.searchBar.isHidden = false
            }
        }else{
            UIView.animate(withDuration: 0.3) {
                self.searchBar.isHidden = true
            }
        }
    }
    
}


extension MoviesListVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchStr.accept(searchText)
    }
}
