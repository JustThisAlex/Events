//
//  UserRegistration.swift
//  Events
//
//  Created by scott harris on 3/3/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

struct UserRegistration: Codable {
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
    }
    
}
