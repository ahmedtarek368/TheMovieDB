//
//  MovieCell.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import UIKit
import RxSwift

class MovieCell: UICollectionViewCell {

    //MARK:- Outlets
    @IBOutlet private weak var moviePoster: UIImageView!
    @IBOutlet private weak var movieName: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    //MARK:- Variables
    var isFavorite: Bool = false
    private var gradientLayer: CAGradientLayer!
    private (set) var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        if gradientLayer != nil{
            gradientLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height/2)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gradientLayer = CAGradientLayer()
        addGradientLayer()
    }
    
    func setData(poster: String?, name: String){
        self.movieName.text = name
        if let poster = poster{
            let url = NSURL(string: Poster.Size.w342+poster)! as URL
            self.moviePoster.sd_setImage(with: url) {[weak self] img, _, _, _ in
                guard let self = self else {return}
                self.loadingIndicator.isHidden = true
                if let _ = img {
                }else{
                    self.moviePoster.image = UIImage(named: "placeholder")
                }
            }
        }else{
            self.loadingIndicator.isHidden = true
            self.moviePoster.image = UIImage(named: "placeholder")
        }
    }
    
    private func addGradientLayer(){
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height/4)
        gradientLayer.colors = [UIColor.black.cgColor.copy(alpha: 0.5)!, UIColor.black.cgColor.copy(alpha: 0)!]
        moviePoster.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    ///Checking favorite status to update button icon
    func checkFavorite(isFavorite: Bool){
        self.isFavorite = isFavorite
        if isFavorite{
            favoriteBtn.setImage(UIImage(named: "favorite")?.sd_tintedImage(with: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)), for: .normal)
        }else{
            favoriteBtn.setImage(UIImage(named: "favoriteBorder"), for: .normal)
        }
    }
    
    ///Get movie poster image as Data
    func getPosterData() -> Data?{
        return moviePoster.image?.jpegData(compressionQuality: 1)
    }


}
