//
//  DataModel.swift
//  SampleDemoApp
//
//  Created by Nitesh Meshram on 02/06/19.
//  Copyright © 2019 Nitesh Meshram. All rights reserved.
//

import Foundation

import Foundation.NSURL

// Service creates DataModel objects
class DataModel {

    let title: String
    let description: String
    let imageHref: URL
    let index: Int
    var downloaded = false
    
    init(title: String, description: String, imageHref: URL, index: Int) {
        self.title = title
        self.description = description
        self.imageHref = imageHref
        self.index = index
    }
    
}
