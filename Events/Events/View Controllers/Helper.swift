//
//  Helper.swift
//  Events
//
//  Created by Alexander Supe on 05.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

struct Helper {
    static let username = chain.get("username")
    static let email = chain.get("email")
    static let chain = KeychainSwift.shared
    static func logOut() {
        chain.set("", forKey: "userID")
        chain.set("", forKey: "username")
        chain.set("", forKey: "email")
        chain.set("", forKey: "token")
        chain.set("", forKey: "password")
        chain.set(false, forKey: "authenticated")
    }
}
