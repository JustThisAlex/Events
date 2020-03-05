//
//  PrivacyViewController.swift
//  Events
//
//  Created by Alexander Supe on 03.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit
import WebKit

class PrivacyViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: URL(string: "https://eventsapp.carrd.co")!))
    }
}
