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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = KeychainSwift.shared.get("username") ?? ""
        emailLabel.text = KeychainSwift.shared.get("email") ?? ""
        if let imageData = KeychainSwift.shared.getData("userImage") {
            userImage.image = UIImage(data: imageData)
        }
        temp.setTitle(KeychainSwift.shared.get("tempPref") ?? "°F", for: .normal)
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
