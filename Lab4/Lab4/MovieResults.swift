//
//  MovieResults.swift
//  Lab4
//
//  Created by Xiaoyi Xie on 10/17/16.
//  Copyright © 2016 Xiaoyi Xie. All rights reserved.
//

import Foundation
class MovieResults {
    let title: String?
    let rated: String
    let released: String
    let imageURL: String
    let plot: String
    
    init (title: String, rated: String, released: String, imageURL: String, plot: String ){
        self.title = title
        self.rated = rated
        self.released = released
        self.imageURL = imageURL
        self.plot = plot
    }
}