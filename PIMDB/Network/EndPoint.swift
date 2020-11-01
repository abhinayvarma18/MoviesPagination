//
//  EndPoint.swift
//  AliveCorAssignment
//
//  Created by abhinay varma on 30/10/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import Foundation

struct Constants {
    static let apiKey:String = "34c902e6393dc8d970be5340928602a7"
}

enum EndPoint:String {
    
    case BASE_URL = "https://api.themoviedb.org/3"
    case imageBaseURL = "https://image.tmdb.org/t/p/w500"
    
    //MARK:- URLs
    case currentMoviesPlayingURL = "/movie/now_playing?language=en-US&api_key=34c902e6393dc8d970be5340928602a7"

}

//MARK:- EndPoint extension for URL
extension EndPoint{
    
    var url: String{
        
        switch self {
        case .BASE_URL:
            return self.rawValue
        default:
            let tempString = "\(EndPoint.BASE_URL.rawValue)\(self.rawValue)"
            return tempString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        }
        
    }
    
}
