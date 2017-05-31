//
//  RedditAPI.swift
//  Recipeasy
//
//  Created by Jay Dhanota on 5/30/17.
//  Copyright © 2017 Jay Dhanota. All rights reserved.
//

import Foundation

enum RedditError: Error {
    case invalidJSONData
}

enum Method: String {
    case hotPosts = "hot.json"
    case newPosts = "new.json"
    case topPosts = "top.json"
}

struct RedditAPI {
    
    private static let baseURLString = "https://reddit.com/r/gifrecipes/"
    
    // Get the default hot posts
    static var hotPostsURL: URL {
        return redditURL(method: .hotPosts, parameters: nil)
    }
    
    // Get new posts
    static var newPostsURL: URL {
        return redditURL(method: .newPosts, parameters: nil)
    }
    
    // Get the top posts from the last week
    static var topPostsURL: URL {
        return redditURL(method: .topPosts, parameters: ["sort":"top", "t":"week"])
    }
    
    // Builds our URL
    // @param method: The method of content we want - new/top/hot
    // @param parameters: Any additional parameters we want in our query
    // @returns: The completed URL of the given request
    private static func redditURL(method: Method,
                                  parameters: [String:String]?) -> URL {
        
        var components = URLComponents(string: baseURLString + method.rawValue)!
        var queryItems = [URLQueryItem]()
        
        //figure out better way to do this
        let baseParams = [
            "limit": "15"
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        
        components.queryItems = queryItems
        
        print("URL: \(components.url!)")
        return components.url!
    
    }
    
    // Builds up a collection of recipes, if able to retrieve them - CALLED in RecipeStore.swift
    // @param data: Data retrieved after making the get request
    // @returns: Success RecipesResult if able to build an array of recipes. False RecipesResult if there was an error
    static func recipes(fromJSON data: Data) -> RecipesResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let recipes = jsonDictionary["data"] as? [String:Any],
                let recipesArray = recipes["children"] as? [[String:Any]] else {
                    
                    // The JSON structure didnt match the expected outcome
                    return .failure(RedditError.invalidJSONData)
            }
            
            var finalRecipes = [Recipe]()
            
            for recipeJSON in recipesArray {
                if let recipe = recipe(fromJSON: recipeJSON) {
                    finalRecipes.append(recipe)
                }
            }
            
            if finalRecipes.isEmpty && !recipesArray.isEmpty {
                //Weren't able to proccess any recipes
                return .failure(RedditError.invalidJSONData)
            }
            
            return .success(finalRecipes)
            
        } catch let error {
            return .failure(error)
        }
    }
    
    // Handles each individual Recipe in JSON format and returns a built Recipe object
    // @param json: The individual recipe json object
    // @returns: A recipe object if able possible, nil otherwise
    private static func recipe(fromJSON json: [String:Any]) -> Recipe? {
        
        guard
            let data = json["data"] as? [String:Any],
            let id = data["id"] as? String,
            let title = data["title"] as? String,
            let dateDouble = data["created"] as? Double,
            let urlString = data["url"] as? String,
            let ups = data["ups"] as? Int,
            let url = URL(string: urlString) else {
                
                //Not getting all fields required to create recipe object
                return nil
        }
        let stringURL = url.absoluteString
        var finalURL = ""
        
        // Takes care of some posts we don't want when using hotPostsURL
        if(stringURL.contains("comments")) {
            return nil
        }
        
        if(stringURL.contains("gfycat")) {
            // Handle GFYCAT gifs...
            let gyfcatIdentifier = stringURL.components(separatedBy: "/")
            finalURL += "https://thumbs.gfycat.com/" + gyfcatIdentifier.last! + "-size_restricted.gif"
        } else {
            // Handle imgur/reddit hosted gif
            finalURL = url.deletingPathExtension().absoluteString
            finalURL.append(".gif")
        }
        
        return Recipe(id: id, title: title, remoteURL: URL(string: finalURL)!, ups: ups, date: dateDouble.getDateStringFromUTC())
        
    }
}


