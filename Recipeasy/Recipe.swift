//
//  Recipe.swift
//  Recipeasy
//
//  Created by Jay Dhanota on 5/30/17.
//  Copyright © 2017 Jay Dhanota. All rights reserved.
//

import Foundation

class Recipe {
    let id: String
    let title: String
    let remoteURL: URL
    let ups: Int
    let date: String
    
    init(id: String, title: String, remoteURL: URL, ups: Int, date: String) {
        self.id = id
        self.title = title
        self.remoteURL = remoteURL
        self.ups = ups
        self.date = date
    }
    
}
