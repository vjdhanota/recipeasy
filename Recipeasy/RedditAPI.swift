//
//  RedditAPI.swift
//  Recipeasy
//
//  Created by Jay Dhanota on 5/30/17.
//  Copyright © 2017 Jay Dhanota. All rights reserved.
//

import Foundation

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
    private static func redditURL(method: Method,
                                  parameters: [String:String]?) -> URL {
        
        var components = URLComponents(string: baseURLString + method.rawValue)!
        var queryItems = [URLQueryItem]()
        
        
        let baseParams = [
            "limit": "5"
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
}


