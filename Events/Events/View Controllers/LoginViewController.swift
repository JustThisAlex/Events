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
    
    let controller = ApiController.shared
    let chain = KeychainSwift.shared
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        usernameField.delegate = self
        continueButton.titleLabel?.leadingAnchor.constraint(equalTo: continueButton.leadingAnchor, constant: 20).isActive = true
        continueButton.titleLabel?.trailingAnchor.constraint(equalTo: continueButton.trailingAnchor, constant: -20).isActive = true
        continueButton.titleLabel?.textAlignment = .center
    }
    
    // MARK: - IBActions
    @IBAction func login(_ sender: Any) {
        guard let email = email.text, let password = password.text else { return }
        chain.set(email, forKey: "email")
        let street = chain.get("address")
        let city = chain.get("city")
        let zipcode = chain.get("zipcode")
        let latitude = chain.get("latitude")
        let longitude = chain.get("longitude")
        if segment.selectedSegmentIndex == 0 {
            controller.signIn(user: User(id: nil, email: email, username: nil, password: password, streetAddress: nil, city: nil, zipcode: nil, businessName: nil, latitude: nil, longitude: nil, country: nil)) { result in
                DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    if error == .userNotFound {
                        self.alert("Your email address or password is wrong", "If you want to sign up choose that option above")
                    } else {
                        self.isError(nil)
                    }
                case .success:
                    MainViewController.authenticated = true;
                    self.performSegue(withIdentifier: "FinishSegue", sender: nil)
                }
                }
            }
        } else {
            guard let username = usernameField.text else { return }
            chain.set(username, forKey: "username")
            controller.signUp(user: User(id: nil, email: email, username: username, password: password, streetAddress: street, city: city, zipcode: zipcode, businessName: nil, latitude: latitude, longitude: longitude, country: nil)) { (result) in
                DispatchQueue.main.async {
                switch result {
                case .failure: return
                case .success(let user):
                    self.chain.set(user.id ?? "", forKey: "userID")
                    MainViewController.authenticated = true
                    self.performSegue(withIdentifier: "FinishSegue", sender: nil)
                }
            }
            }
        }
    }
    
    @IBAction func ckLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "FinishSegue", sender: nil)
        chain.set("", forKey: "userID")
        chain.set("", forKey: "username")
        chain.set("", forKey: "email")
        chain.set("", forKey: "token")
        MainViewController.authenticated = true
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
    
    // MARK: - Helper Methods
    @discardableResult private func isError(_ error: Error?) -> Bool {
        if error != nil {
            print(error.debugDescription)
            alert("An error occured", "Please try again later")
            return true
        }
        return false
    }
    
    private func alert(_ title: String, _ message: String) {
        let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
        popup.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.present(popup, animated: true)
    }
    
}
