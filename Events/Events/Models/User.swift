//
//  User.swift
//  Events
//
//  Created by scott harris on 3/3/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: String?
    let email: String
    let username: String?
    let password: String
    let streetAddress: String?
    let city: String?
    let zipcode: String?
    let businessName: String?
    let latitude: String?
    let longitude: String?
    
    init(id: String?, email: String, username: String?, password: String, streetAddress: String?, city: String?, zipcode: String?, businessName: String?, latitude: String?, longitude: String?) {
        self.id = id
        self.email = email
        self.username = username
        self.password = password
        self.streetAddress = streetAddress
        self.city = city
        self.zipcode = zipcode
        self.businessName = businessName
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(id: String, user: User) {
        self.id = id
        self.email = user.email
        self.username = user.username
        self.password = user.password
        self.streetAddress = user.streetAddress
        self.city = user.city
        self.zipcode = user.zipcode
        self.businessName = user.businessName
        self.latitude = user.latitude
        self.longitude = user.longitude
    }
    
}
