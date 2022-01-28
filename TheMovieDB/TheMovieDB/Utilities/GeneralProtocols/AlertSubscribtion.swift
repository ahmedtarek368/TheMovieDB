//
//  AlertSubscribtion.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import Foundation
import RxSwift

protocol AlertObservable {
    var alertObservable: Observable<String> { get }
}
