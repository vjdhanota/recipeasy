//
//  FeedViewController.swift
//  Recipeasy
//
//  Created by Jay Dhanota on 5/30/17.
//  Copyright © 2017 Jay Dhanota. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var store: RecipeStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchPosts(withURL: RedditAPI.hotPostsURL) { (recipesResult) -> Void in
            
            switch recipesResult {
            case let .success(recipes):
                print("Successfully found \(recipes.count) recipes")
            case let .failure(error):
                print("Error fetching recipes: \(error)")
            }
        }
    
    }
}
