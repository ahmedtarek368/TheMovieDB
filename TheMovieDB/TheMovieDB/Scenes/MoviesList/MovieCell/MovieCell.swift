//
//  MovieCell.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import UIKit

class MovieCell: UICollectionViewCell {

    @IBOutlet private weak var moviePoster: UIImageView!
    @IBOutlet private weak var movieName: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    private var gradientLayer: CAGradientLayer!
    
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


}
