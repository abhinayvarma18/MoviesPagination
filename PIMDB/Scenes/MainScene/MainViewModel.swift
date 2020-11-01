//
//  MainViewModel.swift
//  AliveCorAssignment
//
//  Created by abhinay varma on 30/10/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import Foundation


protocol UIUpdateDelegate:class {
    func reloadTableView()
}

class MainViewModel {
    
    weak var delegate:UIUpdateDelegate?
    var models:[Movie] = []
    var currentPage = 1
    
    let networkManager = MovieService.sharedInstance
    let databaseManager = DatabaseManager.shared
    
    var totalPages = -1
    
    func getMovies() {
        
        let modelsFromDB = self.databaseManager.getMovies(forPage: currentPage)
        //the db doesnt have models for the page so load it from network
        if modelsFromDB.count == 0 {
            print("Loading models from Network for page \(currentPage)")
            networkManager.getMovies(currentPage) { [weak self](model, error) in
                if error == nil && model != nil {
                    let modelsFromServer = model?.results ?? []
                    self?.totalPages = model?.totalPages ?? 0
                    self?.databaseManager.saveModels(models: modelsFromServer, forPage: self?.currentPage ?? 1)
                    if let modelsFromDB = self?.databaseManager.getMovies(forPage: self?.currentPage ?? 1) {
                        self?.models.append(contentsOf: modelsFromDB)
                        self?.delegate?.reloadTableView()
                    }
                }
                //error
            }
        }else {
            print("Loading models from DB for page \(currentPage)")
            models.append(contentsOf: modelsFromDB)
            self.delegate?.reloadTableView()
            
            networkManager.getMovies(currentPage) { [weak self](model, error) in
               if error == nil && model != nil {
                    let modelsFromServer = model?.results ?? []
                    self?.totalPages = model?.totalPages ?? 0
                    let idsFromDB = modelsFromDB.map { (movie) -> Int in
                        return Int(movie.id)
                    }
                    for model in modelsFromServer {
                        if !idsFromDB.contains(model.id ?? 0) {
                            self?.reloadDataForPage(modelsFromServer)
                            break
                        }
                    }
               }
            }
            
        }
    }
    
    func reloadDataForPage(_ newMovies:[Movies]) {
        self.databaseManager.deleteMovies(forPage: currentPage)
        self.databaseManager.saveModels(models: newMovies, forPage: currentPage)
        let newModels = self.databaseManager.getMovies(forPage: currentPage)
//        models.removeAll { (movie) -> Bool in
//            return movie.pageNum == currentPage
//        }
        
        models = models.filter({ (movie) -> Bool in
            return movie.pageNum != 0
        })
        models.append(contentsOf: newModels)
        self.delegate?.reloadTableView()
    }
    
    func reloadDataOnRefresh() {
        self.databaseManager.deleteAllMovies()
        self.currentPage = 1
        self.models = []
        networkManager.getMovies(currentPage) { [weak self](model, error) in
           if error == nil && model != nil {
                let modelsFromServer = model?.results ?? []
                self?.totalPages = model?.totalPages ?? 0
                self?.databaseManager.saveModels(models: modelsFromServer, forPage: self?.currentPage ?? 1)
                if let modelsFromDB = self?.databaseManager.getMovies(forPage: self?.currentPage ?? 1) {
                    self?.models.append(contentsOf: modelsFromDB)
                    self?.delegate?.reloadTableView()
                }
           }
        }
    }
    
    func updateFav(_ model:Movie) {
        databaseManager.updateEntryToFav(forId:Int(model.id),!model.favorite)
    }
    
}
