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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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


}
