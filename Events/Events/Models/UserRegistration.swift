//
//  UserRegistration.swift
//  Events
//
//  Created by scott harris on 3/3/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

struct UserRegistration: Codable {
    let identifier: String
    enum CodingKeys: String, CodingKey {
        case identifier = "_id"
    }
}
