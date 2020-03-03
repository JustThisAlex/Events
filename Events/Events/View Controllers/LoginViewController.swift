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
    @IBOutlet weak var password: StylizedTextField!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var continueButton: CustomButton!
    @IBOutlet weak var skipButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        continueButton.titleLabel?.leadingAnchor.constraint(equalTo: continueButton.leadingAnchor, constant: 20).isActive = true
        continueButton.titleLabel?.trailingAnchor.constraint(equalTo: continueButton.trailingAnchor, constant: -20).isActive = true
        continueButton.titleLabel?.textAlignment = .center
    }
    
    // MARK: - IBActions
    @IBAction func login(_ sender: Any) {
        guard let email = email.text, let password = password.text else { return }
        if segment.selectedSegmentIndex == 0 {
            
//            UserController.shared.logIn(with: UserRepresentation(email: email, password: password)) { (error) in
//                DispatchQueue.main.async {
//                    if !self.isError(error) {
//                        DispatchQueue.main.async {
//                            HomeViewController.authenticated = true
//                            self.performSegue(withIdentifier: "FinishSegue", sender: nil)
//                        }
//                    }
//                }
//            }
        } else {
            
//            UserController.shared.signUp(with: UserRepresentation(email: email, password: password, phoneNumber: phoneNumber)) { (error) in
//                DispatchQueue.main.async {
//                    if !self.isError(error) {
//                        HomeViewController.authenticated = true
//                        self.performSegue(withIdentifier: "FinishSegue", sender: nil)
//                    }
//                }
//            }
        }
    }
    
    @IBAction func ckLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "FinishSegue", sender: nil)
//        HomeViewController.authenticated = true
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        if segment.selectedSegmentIndex == 0 {
            titleLabel.text = "Login"
            continueButton.titleLabel?.text = "Login"
        } else {
            titleLabel.text = "Sign Up"
            continueButton.titleLabel?.text = "Sign Up"
        }
    }
    
    // MARK: - TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Helper Methods
    private func isError(_ error: Error?) -> Bool {
        if error != nil {
            print(error.debugDescription)
            let popup = UIAlertController(title: "An error occured", message: "Please try again later", preferredStyle: .alert)
            popup.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            self.present(popup, animated: true)
            return true
        }
        return false
    }
    
}
