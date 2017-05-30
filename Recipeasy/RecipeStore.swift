//
//  RecipeStore.swift
//  Recipeasy
//
//  Created by Jay Dhanota on 5/30/17.
//  Copyright © 2017 Jay Dhanota. All rights reserved.
//

import Foundation

class RecipeStore {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    
    func fetchPosts(withURL url: URL) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, reponse, error) -> Void in
            
            if let jsonData = data {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                }
            } else if let requestError = error {
                print("Error fetching hot posts: \(requestError)")
            } else {
                print("Unexpected error with request")
            }
        }
        task.resume()
    }
    
    
    //    func fetchHotPosts() {
    //
    //        let url = RedditAPI.hotPostsURL
    //        let request = URLRequest(url: url)
    //        let task = session.dataTask(with: request) { (data, reponse, error) -> Void in
    //
    //            if let jsonData = data {
    //                if let jsonString = String(data: jsonData, encoding: .utf8) {
    //                    print(jsonString)
    //                }
    //            } else if let requestError = error {
    //                print("Error fetching hot posts: \(requestError)")
    //            } else {
    //                print("Unexpected error with request")
    //            }
    //        }
    //        task.resume()
    //    }
}
