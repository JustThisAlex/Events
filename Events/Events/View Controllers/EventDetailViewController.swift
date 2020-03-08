//
//  PlantDetailViewController.swift
//  Plants
//
//  Created by Alexander Supe on 01.02.20.
//

import UIKit

class EventDetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - IBOutlets
    // FORM
    @IBOutlet weak var eventImageView: CustomImage!
    @IBOutlet weak var eventImageButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleField: StylizedTextField!
    @IBOutlet weak var titleSeperator: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressField: StylizedTextField!
    @IBOutlet weak var addressSeperator: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionField: StylizedTextField!
    @IBOutlet weak var descriptionSeperator: UIView!
    @IBOutlet weak var fromTime: StylizedTextField!
    @IBOutlet weak var toTime: StylizedTextField!
    @IBOutlet weak var urlField: StylizedTextField!
    
    // BUTTONS
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: CustomButton!
    @IBOutlet weak var deleteButton: CustomButton!
    
    // MARK: - Properies
    var event: Event?
    var eventController = EventController.shared
    let imagePC = UIImagePickerController()
    
    var creating = true
    var currentlyEditing = false
    var editingPermission: Bool {
        (event?.eventCreator == Helper.chain.get("userID")) || creating
    }
    
    var pickedFromDate: String?
    var pickedToDate: String?
    var pickedLocation: Location? { didSet { addressField.text = pickedLocation?.street ?? "" } }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        descriptionField.delegate = self
        urlField.delegate = self
        imagePC.delegate = self
        addressField.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(setLocation),
                                               name: NSNotification.Name(rawValue: "location"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        if let event = event {
            guard let startDate = ISO8601DateFormatter().date(from: event.eventStart ?? ""),
                let endDate = ISO8601DateFormatter().date(from: event.eventEnd ?? "") else { return }
            titleField.text = event.eventTitle
            addressField.text = event.eventAddress
            descriptionField.text = event.eventDescription
            fromTime.text = formatDate(startDate)
            toTime.text = formatDate(endDate)
            urlField.text = event.externalLink
            Helper.setImage(for: event.externalLink, in: eventImageView)
            if let image = event.photo { eventImageView.image = UIImage(data: image) } else {
                eventImageView.isHidden = true
            }
            creating = false
        }
        currentlyEditing = false
        eventImageButton.isHidden = true
        if creating { createMode() }
        else { viewMode() }
    }
    
    // MARK: - Modes
    func createMode() {
        editMode()
        deleteButton.isHidden = true
    }
    
    func editMode() {
        fromTime.setInputViewDatePicker(target: self, selector: #selector(fromPicked))
        toTime.setInputViewDatePicker(target: self, selector: #selector(toPicked))
        fromTime.isUserInteractionEnabled = true
        toTime.isUserInteractionEnabled = true
        editButton.isEnabled = false
        editButton.tintColor = .clear
        saveButton.isHidden = false
        eventImageButton.isHidden = false
        deleteButton.isHidden = false
    }
    
    func viewMode() {
        if editingPermission {
            editButton.isEnabled = true
            editButton.tintColor = .black
        } else {
            editButton.isEnabled = false
            editButton.tintColor = .clear
        }
        fromTime.isUserInteractionEnabled = false
        toTime.isUserInteractionEnabled = false
        saveButton.isHidden = true
        eventImageButton.isHidden = true
        deleteButton.isHidden = true
    }
    
    // MARK: - IBActions
    @IBAction func edit(_ sender: Any) {
        guard editingPermission else { return }
        currentlyEditing = true
        editMode()
    }
    
    
    @IBAction func deletePressed(_ sender: Any) {
        if let event = event {
            eventController.delete(event: event)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func openMap(_ sender: Any) {
        if (editingPermission  && currentlyEditing) || creating {
            performSegue(withIdentifier: "OpenMap", sender: nil)
        }
    }
    
    @IBAction func imageButton(_ sender: Any) {
        imagePC.allowsEditing = true
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default , handler: { (sction: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePC.sourceType = .camera
                self.present(self.imagePC, animated: true, completion: nil) }
            else { print("Camera not available") } }))
        actionSheet.addAction(UIAlertAction(title: "Photo Libary", style: .default , handler: { (sction: UIAlertAction) in
            self.imagePC.sourceType = .photoLibrary
            self.present(self.imagePC, animated: true, completion: nil) }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        save()
    }
    
    // MARK: - ImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true, completion: nil)
        eventImageButton.isHidden = true
        urlField.text = UUID().uuidString
        Helper.saveImage(with: image.pngData(), for: urlField.text)
        eventImageView.image = image
    }
    
    // MARK: - Helper Methods
    private func save() {
        guard let title = titleField.text,
            let address = addressField.text,
            let description = descriptionField.text else { return }
        guard !title.isEmpty else { titleSeperator.backgroundColor = .systemRed; titleLabel.textColor = .systemRed; return }
        guard !address.isEmpty else { addressSeperator.backgroundColor = .systemRed; addressLabel.textColor = .systemRed; return }
        guard !description.isEmpty else { descriptionSeperator.backgroundColor = .systemRed; descriptionLabel.textColor = .systemRed; return }
        currentlyEditing = false
        viewMode()
        if creating {
            guard let pickedLocation = pickedLocation else { return }
            eventController.createEvent(title: title,
                                        description: description,
                                        address: address,
                                        location: pickedLocation.latitude ?? ".",
                                        eventStart: pickedFromDate ?? ".",
                                        eventEnd: pickedToDate ?? ".",
                                        externalLink: urlField.text ?? "",
                                        creator: (Helper.chain.get("userID") ?? "").isEmpty ? "." : Helper.chain.get("userID")!,
                                        city: pickedLocation.city ?? ".",
                                        country: pickedLocation.country ?? ".")
            navigationController?.popViewController(animated: true)
        } else {
            guard let event = event else { return }
            event.eventTitle = title
            event.eventDescription = description
            event.eventAddress = address
            if let location = pickedLocation?.latitude { event.eventGeolocation = location }
            if let fromDate = pickedFromDate { event.eventStart = fromDate }
            if let toDate = pickedToDate { event.eventEnd = toDate }
            if let url = urlField.text { event.externalLink = url }
            if let city = pickedLocation?.city { event.eventCity = city }
            if let country = pickedLocation?.country { event.eventCountry = country }
            eventController.updateEvent(event: event)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if titleField.isFirstResponder || descriptionField.isFirstResponder { return }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 { self.view.frame.origin.y -= keyboardSize.height }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 { self.view.frame.origin.y = 0 }
    }
    @objc func fromPicked() { datePicked(true, in: fromTime) }
    @objc func toPicked() { datePicked(false, in: toTime) }
    @objc func datePicked(_ from: Bool, in textfield: UITextField) {
        if let datePicker = textfield.inputView as? UIDatePicker {
            textfield.text = formatDate(datePicker.date)
            if from {
                pickedFromDate = ISO8601DateFormatter().string(from: datePicker.date)
            } else {
                pickedToDate = ISO8601DateFormatter().string(from: datePicker.date)
            }
        }
        textfield.resignFirstResponder()
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .short
        dateformatter.doesRelativeDateFormatting = true
        return dateformatter.string(from: date)
    }
    
    @objc func setLocation(_ notification: NSNotification) {
        pickedLocation = notification.userInfo?["loc"] as? Location
    }
    
    // MARK: - TextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if currentlyEditing || creating {
            return true
        } else { return false }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MapsViewController {
            destination.isSelecting = true
        }
    }
    
}

extension UITextField {
    func setInputViewDatePicker(target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .dateAndTime
        self.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .done, target: target, action: selector)
        toolbar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolbar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
