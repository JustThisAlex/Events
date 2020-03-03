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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = KeychainSwift.shared.get("username") ?? ""
        emailLabel.text = KeychainSwift.shared.get("email") ?? ""
        if let imageData = KeychainSwift.shared.getData("userImage") {
            userImage.image = UIImage(data: imageData)
        }
    }
}
