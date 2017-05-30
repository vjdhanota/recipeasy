//
//  RecipeStore.swift
//  Recipeasy
//
//  Created by Jay Dhanota on 5/30/17.
//  Copyright © 2017 Jay Dhanota. All rights reserved.
//

import Foundation

enum RecipesResult {
    case success([Recipe])
    case failure(Error)

}
class RecipeStore {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    
    func fetchPosts(withURL url: URL, completion: @escaping (RecipesResult) -> Void) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, reponse, error) -> Void in
            
            let result = self.processRecipesRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    private func processRecipesRequest(data: Data?, error: Error?) -> RecipesResult {
        
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return RedditAPI.recipes(fromJSON: jsonData)
        
    }
}
