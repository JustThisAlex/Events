//
//  AppDelegate.swift
//  Events
//
//  Created by Alexander Supe on 29.02.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(Keys.mapsKey)
        return true
    }
}
