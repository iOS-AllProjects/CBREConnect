//
//  User.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 1/28/17.
//  Copyright © 2017 Etjen Ymeraj. All rights reserved.
//

import Foundation
import UIKit
final class User{
    let name: String
    let email: String
    let webiste: String
    let photo: String
    let description: String
    let interests: [String]
    
    init(name: String, email: String, website: String, photo: String, description: String, interests: [String]){
        self.name = name
        self.email = email
        self.webiste = website
        self.photo = photo
        self.description = description
        self.interests = interests
    }
}
