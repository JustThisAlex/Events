//
//  UserDataViewController.swift
//  Events
//
//  Created by Alexander Supe on 05.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class UserDataViewController: UIViewController {

    @IBOutlet weak var emailField: StylizedTextField!
    @IBOutlet weak var usernameField: StylizedTextField!
    @IBOutlet weak var passwordField: StylizedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.text = Helper.email
        usernameField.text = Helper.username
    }
    
    @IBAction func logOut(_ sender: Any) {
        Helper.logOut()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        //TODO: UpdateUsers
        navigationController?.popViewController(animated: true)
    }
}
