//
//  SearchViewController.swift
//  Events
//
//  Created by Alexander Supe on 29.02.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userImage: CustomImage!
    @IBOutlet weak var temp: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    var auth: Bool { Helper.authenticated }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameLabel.text = KeychainSwift.shared.get("username") ?? ""
        emailLabel.text = KeychainSwift.shared.get("email") ?? ""
        if let imageData = KeychainSwift.shared.getData("userImage") {
            userImage.image = UIImage(data: imageData)
        }
        temp.setTitle(KeychainSwift.shared.get("tempPref") ?? "°F", for: .normal)
        
        signInButton.isHidden = auth ? true : false
        signInButton.isUserInteractionEnabled = auth ? false : true
        usernameLabel.isHidden = auth ? false : true
        emailLabel.isHidden = auth ? false : true
    }
    
    @IBAction func manageUser(_ sender: Any) {
        if auth { performSegue(withIdentifier: "ManageUser", sender: nil) }
    }
    
    @IBAction func signIn(_ sender: Any) {
        performSegue(withIdentifier: "LoginSegue", sender: nil)
    }
    
    @IBAction func changeTemp(_ sender: Any) {
        if temp.title(for: .normal) == "°F" {
            temp.setTitle("°C", for: .normal)
            KeychainSwift.shared.set("°C", forKey: "tempPref")
        } else {
            temp.setTitle("°F", for: .normal)
            KeychainSwift.shared.set("°F", forKey: "tempPref")
        }
        NotificationCenter.default.post(name: NSNotification.Name("TempUpdated"), object: nil)
    }
    
}
