//
//  Helper.swift
//  Events
//
//  Created by Alexander Supe on 05.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit
import KeychainSwift
import Alamofire
import SwiftyJSON

struct Helper {
    
    // MARK: Properties
    static let chain = KeychainSwift()
    
    static var username: String? { chain.get("username") }
    static var email: String? { chain.get("email") }
    static var userID: String? { chain.get("userID") }
    static var address: String? { chain.get("address") }
    static var city: String? { chain.get("city") }
    static var country: String? { chain.get("country") }
    static var latitude: String? { chain.get("latitude") }
    static var longitude: String? { chain.get("longitude") }
    static var zipcode: String? { chain.get("zipcode") }
    
    static var authenticated: Bool { Helper.chain.getBool("authenticated") ?? false }
    
    // MARK: General
    static func alert(on view: UIViewController, _ title: String, _ message: String) {
        let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
        popup.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        view.present(popup, animated: true)
    }
    
    // MARK: User Management
    static func login(email: String, password: String, vc: UIViewController, segue: Bool = true) {
        chain.set(email, forKey: "email")
        chain.set(password, forKey: "password")
        ApiController().signIn(user: User(id: nil, email: email, username: nil, password: password, streetAddress: nil, city: nil, zipcode: nil, businessName: nil, latitude: nil, longitude: nil, country: nil)) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    if error == .userNotFound {
                        Helper.alert(on: vc, "Your email address or password is wrong", "If you want to sign up choose that option above")
                    } else {
                        Helper.alert(on: vc, "An error occured", "Please try again later")
                    }
                case .success:
                    chain.set(true, forKey: "authenticated")
                    guard segue else { return }
                    vc.performSegue(withIdentifier: "FinishSegue", sender: nil)
                }
            }
        }
    }
    static func register(email: String, username: String, password: String, vc: UIViewController) {
        chain.set(email, forKey: "email")
        chain.set(username, forKey: "username")
        chain.set(password, forKey: "password")
        ApiController().signUp(user: User(id: nil, email: email, username: username, password: password, streetAddress: address, city: city, zipcode: zipcode, businessName: nil, latitude: latitude, longitude: longitude, country: country)) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure:
                    Helper.alert(on: vc, "An error occured", "Please try again later")
                case .success:
                    chain.set(true, forKey: "authenticated")
                    vc.performSegue(withIdentifier: "FinishSegue", sender: nil)
                }
            }
        }
    }
    static func logout() {
        chain.set("", forKey: "userID")
        chain.set("", forKey: "username")
        chain.set("", forKey: "email")
        chain.set("", forKey: "token")
        chain.set("", forKey: "password")
        chain.set(false, forKey: "authenticated")
    }
    static func updateUser(newUsername: String?, newEmail: String?, newPassword: String?, completion: @escaping () -> Void) {
        guard let checkedEmail = newEmail ?? email,
            let checkedUsername = newUsername ?? username,
            let checkedPassword = newPassword ?? chain.get("password") else { return }
        chain.set(checkedEmail, forKey: "email")
        chain.set(checkedUsername, forKey: "username")
        chain.set(checkedPassword, forKey: "password")
        UserController().update(id: userID ?? ".",
                                email: checkedEmail,
                                password: checkedPassword,
                                username: newUsername ?? username,
                                streetAddress: address,
                                city: city,
                                country: country,
                                zipcode: zipcode,
                                businessName: nil,
                                latitude: latitude,
                                longitude: longitude) { _ in completion() }
    }
    static func saveImage(with image: Data?, for identifier: String?) {
        guard let image = image, let identifier = identifier else { return }
        let baseURL = URL(string: Keys.imagesBaseURL)!.appendingPathComponent("images").appendingPathExtension("json")
        let parameter = [identifier : image.base64EncodedString()]
        AF.request(baseURL, method: .put, parameters: parameter, encoding: JSONEncoding.default).resume()
    }
    static func setImage(for identifier: String?, in view: CustomImage, tableView: UITableView? = nil) {
        guard let identifier = identifier, !identifier.isEmpty else { return }
        let baseURL = URL(string: Keys.imagesBaseURL)!.appendingPathComponent("images").appendingPathExtension("json")
        URLSession.shared.dataTask(with: baseURL) { newData, _, error in
            print(error.debugDescription)
            guard let data = Data(base64Encoded: JSON(newData ?? Data())[identifier].stringValue) else { return }
            DispatchQueue.main.async {
                view.image = UIImage(data: data)
                if let tableView = tableView {
                tableView.reloadData()
                }
            }
        }.resume()
    }
}

