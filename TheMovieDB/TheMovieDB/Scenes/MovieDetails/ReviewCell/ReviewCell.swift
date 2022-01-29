//
//  ReviewCell.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 29/01/2022.
//

import UIKit
import SwiftyStarRatingView

class ReviewCell: UITableViewCell {

    @IBOutlet weak var authorAvatar: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var rate: SwiftyStarRatingView!
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rate.backgroundColor = .clear
    }

    func setData(authorName: String, authorAvatar: String?, authorRate: Int?, content: String){
        self.authorName.text = authorName
        self.review.text = content
        if let rate = authorRate{
            self.rate.value = CGFloat(rate)
        }
        if let avatar = authorAvatar{
            if avatar.contains("https"){
                self.setAvatar(img: avatar)
            }else{
                let img = Poster.Size.w185+avatar
                print(img)
                self.setAvatar(img: img)
            }
        }
    }
    
    private func setAvatar(img: String){
        let url = NSURL(string: img)! as URL
        self.authorAvatar.sd_setImage(with: url) {[weak self] img, _, _, _ in
            guard let self = self else {return}
            self.loadingIndicator.isHidden = true
            if let _ = img{
            }else{
                self.authorAvatar.image = UIImage(named: "user")
            }
        }
    }
    
}
