//
//  MainViewController.swift
//  Events
//
//  Created by Alexander Supe on 03.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    static var authenticated = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        // TODO: Get weather and call appropriate setting func
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = KeychainSwift.shared.get("City")
    }
    
    func changeWeather(temperature: String, condition: WeatherConditions) {
        weatherLabel.text = "\(temperature)°"
        weatherIcon.image = UIImage(imageLiteralResourceName: condition.rawValue)
    }
}

enum WeatherConditions: String {
    case sunny
    // TODO: Complete List
}
