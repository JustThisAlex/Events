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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = KeychainSwift.shared.get("City")
        navigationController?.navigationBar.barStyle = .black
        // TODO: Get weather and call appropriate setting func
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
