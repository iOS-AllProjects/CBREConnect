//
//  Feed.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/19/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import Foundation

final class Feed{
    let title: String
    let description: String
    let type: String
    let category: String
    let topic: String
    let date: NSDate
    let location: String
    let user: String
    let imagePath: String
    
    init(title: String, description: String, type: String, category: String, topic: String, date: NSDate, location: String, user: String, imagePath: String){
        self.title = title
        self.description = description
        self.type = type
        self.category = category
        self.topic = topic
        self.date = date
        self.location = location
        self.user = user
        self.imagePath = imagePath
    }
}
