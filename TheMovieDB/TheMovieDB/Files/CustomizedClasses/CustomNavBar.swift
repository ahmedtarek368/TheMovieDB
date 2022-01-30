//
//  CustomizedClasses.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 29/01/2022.
//

import UIKit

extension UINavigationBar{
    
    func fullTranslucent(){
        setBackgroundImage(UIImage(), for:.default)
        backgroundColor = .clear
        isTranslucent = true
    }
    
    func darkTranslucent(){
        setBackgroundImage(UIImage(named: "black1.jpg"), for:.default)
        shadowImage = UIImage()
        backgroundColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
        isTranslucent = false
    }
}
