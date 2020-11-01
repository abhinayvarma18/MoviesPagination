//
//  FavViewModel.swift
//  PIMDB
//
//  Created by abhinay varma on 01/11/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import Foundation

class FavViewModel {
    
    var movies:[Movie] = []
    let dbManager = DatabaseManager.shared
    
    func getFavMovies() {
        movies = dbManager.fetchFavMovies()
    }
    
}
