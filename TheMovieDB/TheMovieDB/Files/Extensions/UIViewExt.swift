//
//  UIViewExt.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 29/01/2022.
//

import UIKit

extension UIView{
    
    func hideKeyBoardWhenTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (dismissKeyBoardView))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyBoardView(){
        self.endEditing(true)
    }
}
