//
//  UIScrollView+Extensions.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import UIKit

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
    
    func isNearBottomEdge() -> Bool {
        let height = self.frame.size.height
        let contentYoffset = self.contentOffset.y
        let distanceFromBottom = self.contentSize.height - contentYoffset
        if distanceFromBottom <= height {
            return true
        }else{
            return false
        }
    }
}
