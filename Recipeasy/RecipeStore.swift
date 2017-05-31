//
//  RecipeStore.swift
//  Recipeasy
//
//  Created by Jay Dhanota on 5/30/17.
//  Copyright © 2017 Jay Dhanota. All rights reserved.
//

import UIKit

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum RecipeError: Error {
    case imageCreationError
}

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
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    private func processRecipesRequest(data: Data?, error: Error?) -> RecipesResult {
        
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return RedditAPI.recipes(fromJSON: jsonData)
        
    }
    
    func fetchImage(for recipe: Recipe, completion: @escaping (ImageResult) -> Void) {
        
        let recipeURL = recipe.remoteURL
        let request = URLRequest(url: recipeURL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
            
        }
        task.resume()
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        
        guard
            let imageData = data,
            let image = UIImage.gif(data: imageData) else {
                
                //couldn't create the image
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(RecipeError.imageCreationError)
                }
        }
        return .success(image)
    }
}
