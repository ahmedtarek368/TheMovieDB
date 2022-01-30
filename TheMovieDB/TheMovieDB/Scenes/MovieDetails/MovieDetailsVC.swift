//
//  MovieDetailsVC.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 29/01/2022.
//

import UIKit
import RxSwift
import SwiftyStarRatingView

class MovieDetailsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet private weak var backGroundImage: UIImageView!
    @IBOutlet private weak var posterHeight: NSLayoutConstraint!
    @IBOutlet private weak var moviePoster: UIImageView!
    @IBOutlet private weak var movieName: UILabel!
    @IBOutlet private weak var rateSelector: SwiftyStarRatingView!
    @IBOutlet private weak var rateAverage: UILabel!
    @IBOutlet private weak var releaseDate: UILabel!
    @IBOutlet private weak var popularity: UILabel!
    @IBOutlet private weak var overviewHeight: NSLayoutConstraint!
    @IBOutlet private weak var overview: UILabel!
    @IBOutlet private weak var readMoreBtn: UIButton!
    @IBOutlet private weak var favoriteBtn: UIBarButtonItem!
    @IBOutlet private weak var reviewsTV: UITableView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    //MARK:- Variables
    var movieId: Int?
    private let disposeBag = DisposeBag()
    private var viewModel: MovieDetailsViewModel!
    
    override func viewWillLayoutSubviews() {
        posterHeight.constant = moviePoster.bounds.width * 1.3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MovieDetailsViewModel(disposeBag: disposeBag)
        subscribeToAlert(viewModel: viewModel, disposeBag: disposeBag)
        setupView()
        registerCell()
        refreshFavStatus()
        addFavoriteObserver()
        subscribeToMoviesDetails()
        bindReviewsToReviewsTV()
        subscribeToDidEndDeceleratingReviews()
        subscribeToFavoriteBtnTap()
        getMovieDetailsData()
    }
    
    private func setupView(){
        self.navigationController?.navigationBar.fullTranslucent()
        rateSelector.backgroundColor = .clear
        viewModel.mainViewHidden.asDriver(onErrorJustReturn: true).drive(scrollView.rx.isHidden).disposed(by: disposeBag)
    }
    
    private func registerCell(){
        reviewsTV.registerNib(cell: ReviewCell.self)
    }
    
    private func getMovieDetailsData(){
        if let movieId = movieId{
            viewModel.getMovieDetailsData(id: movieId)
        }
    }
    
    private func subscribeToMoviesDetails(){
        viewModel.movieDetailsObservable.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] (details) in
            guard let self = self else {return}
            self.setPoster(with: details.posterPath)
            self.movieName.text = details.originalTitle
            self.rateAverage.text = "(\(details.voteAverage)) \(details.voteCount) Votes"
            self.releaseDate.text = details.releaseDate
            self.popularity.text = "\(details.popularity)"
            self.overview.text = details.overview
        }).disposed(by: disposeBag)
    }
    
    private func setPoster(with image: String?){
        if let poster = image{
            let url = NSURL(string: Poster.Size.w500+poster)! as URL
            self.moviePoster.sd_setImage(with: url) {[weak self] img, _, _, _ in
                guard let self = self else {return}
                if let img = img{
                    self.backGroundImage.image = img
                }else{
                    self.backGroundImage.image = UIImage(named: "splash")
                    self.moviePoster.image = UIImage(named: "placeholder")
                }
            }
        }
    }
    
    ///Bind the movie reviews from viewModel to reviewsTV
    ///Drive is called on main thread
    private func bindReviewsToReviewsTV(){
        viewModel.reviewsDriver.drive(reviewsTV.rx.items(cellIdentifier: "ReviewCell", cellType: ReviewCell.self)){(row, review, cell) in
            cell.setData(authorName: review.author, authorAvatar: review.authorDetails.avatarPath, authorRate: review.authorDetails.rating, content: review.content)
        }.disposed(by: disposeBag)
    }
    
    ///Take action when scrolling comes to an end to fetch new reviews
    private func subscribeToDidEndDeceleratingReviews(){
        reviewsTV.rx.didEndDecelerating.subscribe(onNext: {[unowned self] _ in
            if self.reviewsTV.isNearBottomEdge(){
                if let page = self.viewModel.getNextReviewsPage(), let id = movieId{
                    self.viewModel.getMovieReviews(by: page, id: id, isSeprate: true)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    ///listen to favorite btn taps
    private func subscribeToFavoriteBtnTap(){
        favoriteBtn.rx.tap.withLatestFrom(viewModel.movieDetailsObservable).subscribe(onNext: {[unowned self] movie in
            if CDS.instance.isMovieExist(id: movieId!){
                CDS.instance.delete(id: movieId!)
            }else{
                CDS.instance.save(movie: movie, posterData: self.moviePoster.image?.jpegData(compressionQuality: 1))
            }
        }).disposed(by: disposeBag)
    }
    
    ///Always check favorites when its updated to update favorite btn icon
    private func addFavoriteObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavStatus), name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
    
    @objc private func refreshFavStatus(){
        if CDS.instance.isMovieExist(id: movieId!){
            favoriteBtn.image = UIImage(named: "favorite")
        }else{
            favoriteBtn.image = UIImage(named: "favoriteBorder")
        }
    }

    @IBAction func readMoreBtnTapped(_ sender: Any) {
        if overviewHeight != nil{
            overviewHeight.isActive = false
            self.readMoreBtn.isHidden = true
        }
    }
}
