//
//  UICollectionView+Extensions.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import UIKit

extension UICollectionView {
    
    func registerNib<cell: UICollectionViewCell>(cell: cell.Type) {
        let nibName = String(describing: cell)
        self.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
    
    func resizeItem(width: CGFloat? = nil, height: CGFloat? = nil){
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            if let width = width{
                layout.itemSize.width = width
            }
            if let height = height{
                layout.itemSize.height = height
            }
        }
    }
    
}
