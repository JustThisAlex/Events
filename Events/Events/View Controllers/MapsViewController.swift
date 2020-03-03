//
//  MapsViewController.swift
//  Events
//
//  Created by Alexander Supe on 02.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit
import GoogleMaps

class MapsViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var defaultLocation = [48.1351, 11.5820]
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.attributedPlaceholder = NSAttributedString(string: "enter address", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        locationManager.requestAlwaysAuthorization()
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLocation = locationManager.location
            let geocoder = GMSGeocoder()
            guard let location = currentLocation else { return }
            geocoder.reverseGeocodeCoordinate(location.coordinate) { response, error in
                guard let response = response else { return }
                self.textField.text = response.firstResult()?.lines?[0] ?? ""
            }
        }
        let inset = (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation?.coordinate.latitude ?? defaultLocation[0],
                                              longitude: currentLocation?.coordinate.longitude ?? defaultLocation[1],
                                              zoom: 15)
        let frame = CGRect(x: view.bounds.minX, y: view.bounds.minY, width: view.bounds.width, height: view.bounds.height - inset - 50)
        mapView = GMSMapView.map(withFrame: frame, camera: camera)
        mapView.mapStyle = try! GMSMapStyle(contentsOfFileURL: URL(fileReferenceLiteralResourceName: "MapStyle.json"))
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        view.addSubview(mapView)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barStyle = .default
    }
    
    @IBAction func editingEnd(_ sender: Any) {
        addressEnded()
        textField.endEditing(true)
    }
    
    @IBAction func tapOutside(_ sender: Any) {
        textField.endEditing(true)
    }
    @IBAction func dragOutside(_ sender: Any) {
        textField.resignFirstResponder()
    }
    
    
    func addressEnded() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(textField.text ?? "") { (address, error) in
            guard error == nil, let address = address else {
                //Replace with red text below text entry
                print(error)
                return
            }
            
            let alert = UIAlertController(title: "Please select your address", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            for addr in address {
                alert.addAction(UIAlertAction(title: "\(addr.name ?? ""), \(addr.locality ?? "")", style: .default, handler: { _ in
                    
                }))
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func markLocation(postition: CLLocation) {
        mapView.clear()
        let marker = GMSMarker(position: postition.coordinate)
        marker.map = mapView
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                print(self.view.frame.origin.y)
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
