//
//  MainViewController.swift
//  Events
//
//  Created by Alexander Supe on 03.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController {
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    var firstStart: Bool { KeychainSwift.shared.getBool("firstStart") ?? true }
    let chain = KeychainSwift.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        NotificationCenter.default.addObserver(self, selector: #selector(self.tempDidChange),
                                               name: NSNotification.Name("TempUpdated"), object: nil)
        if firstStart {
            KeychainSwift.shared.set(false, forKey: "firstStart")
            performSegue(withIdentifier: "LoginSegue", sender: nil)
        } else {
            getWeather()
            guard let email = chain.get("email"), let password = chain.get("password"),
                !email.isEmpty, !password.isEmpty else { return }
            Helper.login(email: email, password: password, viewController: self, segue: false)
        }
    }

    @objc private func tempDidChange() {
        getWeather()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = KeychainSwift.shared.get("city")
    }

    func getWeather() {
        var temp: String { if (KeychainSwift.shared.get("tempPref") ?? "") == "°C" { return "si" } else { return "us"} }
        AF.request("""
            https://api.darksky.net/forecast/\(Keys.weatherKey)/\(Helper.chain.get("latitude")
            ?? ""),\(Helper.chain.get("longitude")
            ?? "")?units=\(temp)
            """)
            .validate().responseJSON { response in
            switch response.result {
            case .failure:
                self.weatherLabel.text = ""
                self.weatherIcon.image = nil
            case .success(let value):
                let json = JSON(value)
                self.weatherLabel.text = "\(Int(json["currently"]["temperature"].doubleValue))°"
                let icon = json["currently"]["icon"].stringValue
                if icon == "clear-day" || icon ==  "clear-night" || icon ==  "wind" || icon == "fog" {
                    self.weatherIcon.image = UIImage(systemName: "sun.max.fill")
                } else if icon == "sleet" || icon ==  "rain" {
                    self.weatherIcon.image = UIImage(systemName: "cloud.rain.fill")
                } else if icon == "snow" {
                    self.weatherIcon.image = UIImage(systemName: "cloud.snow.fill")
                } else if icon == "cloudy" || icon ==  "partly-cloudy-day" || icon ==  "partly-cloudy-night" {
                    self.weatherIcon.image = UIImage(systemName: "cloud.fill")
                } else {
                    self.weatherIcon.image = UIImage(systemName: "cloud.fill")
                }
            }
        }
    }
}
