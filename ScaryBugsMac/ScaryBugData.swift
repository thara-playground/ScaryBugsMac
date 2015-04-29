//
//  ScaryBugData.swift
//  ScaryBugsMac
//
//  Created by Tomochika Hara on 2015/04/28.
//  Copyright (c) 2015年 isuka.org. All rights reserved.
//

import Foundation

class ScaryBugData: NSObject {
    var title: String
    var rating: Double
    
    override init() {
        self.title = String()
        self.rating = 0.0
    }
    
    init(title: String, rating: Double) {
        self.title = title
        self.rating = rating
    }
}
