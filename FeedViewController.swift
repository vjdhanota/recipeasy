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
        
        store.fetchPosts(withURL: RedditAPI.topPostsURL)
    }
    
}
