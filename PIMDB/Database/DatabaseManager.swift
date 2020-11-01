//
//  DatabaseManager.swift
//  PIMDB
//
//  Created by abhinay varma on 31/10/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit
import CoreData

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private init() {
        
    }
    
    func saveModels(models:[Movies], forPage:Int) {
        let context = appDelegate.persistentContainer.viewContext
        
        for movie in models {
            let newMovie = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: context)
            newMovie.setValue(movie.adult, forKey: CoreDataModelsKeys.adult)
            newMovie.setValue(movie.backdropPath, forKey: CoreDataModelsKeys.backdropPath)
            newMovie.setValue(false, forKey: CoreDataModelsKeys.favorite)
            newMovie.setValue(movie.id, forKey: CoreDataModelsKeys.id)
            newMovie.setValue(forPage, forKey: CoreDataModelsKeys.pageNum)
            newMovie.setValue(movie.popularity, forKey: CoreDataModelsKeys.popularity)
            newMovie.setValue(movie.posterPath, forKey: CoreDataModelsKeys.posterPath)
            newMovie.setValue(movie.title, forKey: CoreDataModelsKeys.title)
            newMovie.setValue(movie.voteAverage, forKey: CoreDataModelsKeys.voteAverage)
            newMovie.setValue(movie.voteCount, forKey: CoreDataModelsKeys.voteCount)
            newMovie.setValue(movie.releaseDate, forKey: CoreDataModelsKeys.releaseDate)
            newMovie.setValue(movie.overview, forKey: CoreDataModelsKeys.overview)
        }
        
        do {
            try context.save()
            print("successfully saved models in DB")
        } catch {
            print("error saving models in DB")
        }
    }
    
    func getMovies(forPage:Int) -> [Movie] {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        let predicate = NSPredicate(format: "pageNum = \(forPage)")

        fetchRequest.predicate = predicate

        do {
            let results = try context.fetch(fetchRequest) as! [Movie]
            return results
        } catch let error as NSError {
            print("error fetching data from database with error -> \(error)")
        }
        return []
    }
    
    func deleteMovies(forPage:Int) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "pageNum = \(forPage)")
        fetchRequest.predicate = predicate

        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Detele all data in Movie error : \(error) \(error.userInfo)")
        }
    }
    
    func updateEntryToFav(forId:Int,_ isFav:Bool) {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        let predicate = NSPredicate(format: "id = \(forId)")
        
        fetchRequest.predicate = predicate
        do
        {
            let results = try context.fetch(fetchRequest)
            (results[0] as AnyObject).setValue(isFav,forKey:"favorite")
            try context.save()
        } catch let error as NSError {
            print("Detele all data in Movie error : \(error) \(error.userInfo)")
        }
    }
    
    func fetchFavMovies() -> [Movie] {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        let predicate = NSPredicate(format: "favorite = 1")
        
        fetchRequest.predicate = predicate
        do
        {
            let results = try context.fetch(fetchRequest)
            return results as? [Movie] ?? []
        }catch {
            print("error fetching favs \(error)")
        }
        return []
    }
    
    func deleteAllMovies() {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Detele all data in Movie error : \(error) \(error.userInfo)")
        }
    }
    
}

