//
//  MapsViewController.swift
//  Events
//
//  Created by Alexander Supe on 02.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit
import GoogleMaps

class MapsViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var defaultLocation = [48.1351, 11.5820]
    var isSelecting: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        style()
        addMap()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            sleep(1)
            addMap()
        }
    }
    
    private func style() {
        textField.attributedPlaceholder = NSAttributedString(string: "enter address", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func addMap() {
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
    @IBAction func buttonClicked(_ sender: Any) {
        addressEnded()
    }
    
    
    func addressEnded() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(textField.text ?? "") { (address, error) in
            guard error == nil, let address = address else {
                self.alert("Sorry, we weren't able to find that address", "Please try being more precise")
                return
            }
            
            let alert = UIAlertController(title: "Please select your address", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            for addr in address {
                alert.addAction(UIAlertAction(title: "\(addr.name ?? ""), \(addr.locality ?? "")", style: .default, handler: { _ in
                    Helper.chain.set(addr.name ?? "", forKey: "address")
                    Helper.chain.set(addr.locality ?? "", forKey: "city")
                    Helper.chain.set(addr.country ?? "", forKey: "country")
                    Helper.chain.set(addr.location?.coordinate.latitude.binade.description ?? "", forKey: "latitude")
                    Helper.chain.set(addr.location?.coordinate.longitude.binade.description ?? "", forKey: "longitude")
                    Helper.chain.set(addr.postalCode ?? "", forKey: "zipcode")
                    if self.isSelecting ?? false {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "location"), object: nil, userInfo: ["loc" : Location(street: addr.name, city: addr.locality, country: addr.country, latitude: addr.location?.coordinate.latitude.description, longitude: addr.location?.coordinate.longitude.description, zipcode: addr.postalCode)])
                        self.isSelecting = false
                        self.dismiss(animated: true, completion: nil)
                    }
                    if self.restorationIdentifier == "mainMapView" {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    } else {
                    self.performSegue(withIdentifier: "locationPicked", sender: nil)
                    }
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
    
    private func alert(_ title: String, _ message: String) {
        let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
        popup.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.present(popup, animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height + 50)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
