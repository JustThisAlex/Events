//
//  UserController.swift
//  Events
//
//  Created by scott harris on 3/4/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

class UserController {
    let apiController = ApiController()
    func create(email: String, password: String,
                username: String? = nil, streetAddress: String? = nil,
                city: String? = nil, country: String? = nil, zipcode: String? = nil,
                businessName: String? = nil, latitude: String? = nil,
                longitude: String? = nil, completion: @escaping (Error?) -> Void) {
        let user = User(identifier: nil, email: email,
                        username: username, password: password,
                        streetAddress: streetAddress, city: city,
                        zipcode: zipcode, businessName: businessName,
                        latitude: latitude, longitude: longitude,
                        country: country)
        apiController.signUp(user: user) { (result) in
            switch result {
            case .failure(let error):
                    NSLog("error returned from sign up: \(error)")
                    completion(error)
            case .success:
                    completion(nil)
            }
        }
    }
    func update(identifier: String, email: String, password: String,
                username: String? = nil, streetAddress: String? = nil,
                city: String? = nil, country: String? = nil, zipcode: String? = nil,
                businessName: String? = nil, latitude: String? = nil,
                longitude: String? = nil, completion: @escaping (Error?) -> Void) {
        
        let user = User(identifier: identifier, email: email,
                        username: username, password: password, streetAddress: streetAddress,
                        city: city, zipcode: zipcode, businessName: businessName,
                        latitude: latitude, longitude: longitude, country: country)
        apiController.update(user: user) { (result) in
            switch result {
            case .failure(let error):
                    NSLog("error returned from sign up: \(error)")
                    completion(error)
            case .success(let user):
                    KeychainSwift.shared.set(user.username ?? "", forKey: "username")
                    KeychainSwift.shared.set(user.email, forKey: "email")
                    KeychainSwift.shared.set(user.identifier ?? "", forKey: "userID")
                    completion(nil)
            }
        }
    }
}
