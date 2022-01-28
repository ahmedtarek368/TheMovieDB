//
//  UITableView+Extensions.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import UIKit

extension UITableView {
    
    func registerNib<cell: UITableViewCell>(cell: cell.Type) {
        let nibName = String(describing: cell)
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
}


