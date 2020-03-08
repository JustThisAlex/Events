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
    
    func create(email: String, password: String, username: String? = nil, streetAddress: String? = nil, city: String? = nil, country: String? = nil, zipcode: String? = nil, businessName: String? = nil, latitude: String? = nil, longitude: String? = nil, completion: @escaping (Error?) -> Void) {
        
        let user = User(id: nil, email: email, username: username, password: password, streetAddress: streetAddress, city: city, zipcode: zipcode, businessName: businessName, latitude: latitude, longitude: longitude, country: country)
        
        apiController.signUp(user: user) { (result) in
            switch result {
                case .failure(let error):
                    NSLog("error returned from sign up: \(error)")
                    completion(error)
                    break
                case .success(_):
                    completion(nil)
                    break
            }
        }
    }
    
    func update(id: String, email: String, password: String, username: String? = nil, streetAddress: String? = nil, city: String? = nil, country: String? = nil, zipcode: String? = nil, businessName: String? = nil, latitude: String? = nil, longitude: String? = nil, completion: @escaping (Error?) -> Void) {
        
        let user = User(id: id, email: email, username: username, password: password, streetAddress: streetAddress, city: city, zipcode: zipcode, businessName: businessName, latitude: latitude, longitude: longitude, country: country)
        
        apiController.update(user: user) { (result) in
            switch result {
                case .failure(let error):
                    NSLog("error returned from sign up: \(error)")
                    completion(error)
                    break
                case .success(let user):
                    Helper.chain.set(user.username ?? "", forKey: "username")
                    Helper.chain.set(user.email, forKey: "email")
                    Helper.chain.set(user.id ?? "", forKey: "userID")
                    completion(nil)
                    break
            }
        }
        
    }
    
}
