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
    }
    
    func darkTranslucent(){
        setBackgroundImage(UIImage(named: "black1.jpg"), for:.default)
        shadowImage = UIImage()
        backgroundColor = .clear
        isTranslucent = true
    }
}
