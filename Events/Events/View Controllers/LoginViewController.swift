//
//  LoginViewController.swift
//  Events
//
//  Created by Alexander Supe on 01.03.20.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var email: StylizedTextField!
    @IBOutlet weak var usernameField: StylizedTextField!
    @IBOutlet weak var password: StylizedTextField!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var continueButton: CustomButton!
    @IBOutlet weak var skipButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        usernameField.delegate = self
        continueButton.titleLabel?.leadingAnchor.constraint(equalTo: continueButton.leadingAnchor, constant: 20)
            .isActive = true
        continueButton.titleLabel?.trailingAnchor.constraint(equalTo: continueButton.trailingAnchor, constant: -20)
            .isActive = true
        continueButton.titleLabel?.textAlignment = .center
    }
    // MARK: - IBActions
    @IBAction func login(_ sender: Any) {
        guard let email = email.text, let password = password.text else { return }
        if segment.selectedSegmentIndex == 0 {
            Helper.login(email: email, password: password, viewController: self)
        } else {
            guard let username = usernameField.text else { return }
            Helper.register(email: email, username: username, password: password, viewController: self)
        }
    }
    @IBAction func withoutLogin(_ sender: Any) {
        Helper.logout()
        self.performSegue(withIdentifier: "FinishSegue", sender: nil)
    }

    @IBAction func segmentChanged(_ sender: Any) {
        if segment.selectedSegmentIndex == 0 {
            titleLabel.text = "Login"
            continueButton.titleLabel?.text = "Login"
            usernameField.isHidden = true
        } else {
            titleLabel.text = "Sign Up"
            continueButton.titleLabel?.text = "Sign Up"
            usernameField.isHidden = false
        }
    }

    // MARK: - TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
