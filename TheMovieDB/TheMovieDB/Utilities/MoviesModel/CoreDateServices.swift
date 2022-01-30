//
//  CDConnections.swift
//  MovieBox
//
//  Created by Ahmed Tarek on 8/7/19.
//  Copyright © 2019 Ahmed Tarek. All rights reserved.
//
import UIKit
import Foundation
import CoreData

typealias CDS = CoreDataServices
class CoreDataServices{
    static let instance = CoreDataServices()
    
    private init(){
        fetchRequest.returnsObjectsAsFaults = false
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
    
    func isMovieExist(id: Int) -> Bool {
        fetchRequest.predicate = NSPredicate(format: "id == %@" , "\(id)")
        let res = try! managedContext.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }

    func save(movie: IsMovie, posterData: Data?){
        let movieEntity = MovieEntity(context: managedContext)
        movieEntity.title = movie.title
        movieEntity.id = Int32(movie.id)
        movieEntity.voteCount = Int32(movie.voteCount)
        movieEntity.voteAverage = movie.voteAverage
        movieEntity.popularity = movie.popularity
        movieEntity.releaseDate = movie.releaseDate
        movieEntity.overview = movie.overview
        movieEntity.poster = posterData
        do{
            try managedContext.save()
            NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
        }catch{}
    }

    func delete(id: Int){
        fetchRequest.predicate = NSPredicate(format: "id == %@" , "\(id)")
        let movies = try! managedContext.fetch(fetchRequest)
        for movie in movies{
            managedContext.delete(movie)
        }
        do{
            try managedContext.save()
            NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
        }catch{}
    }

    func fetchAll() -> [Movie]{
        let MoviesEntities = try! managedContext.fetch(fetchRequest)
        var movies: [Movie] = []
        for movie in MoviesEntities{
            movies.append(Movie(copyFrom: movie))
        }
        return movies
    }
    
}
