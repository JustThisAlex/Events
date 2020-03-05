//
//  EventsTableViewController.swift
//  Events
//
//  Created by Alexander Supe on 01.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {
    var sortingMode: SortingMode = .alphabetical
    var events = [Event]()
    var index = 0
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.segmentChanged(_:)), name: NSNotification.Name("SegmentChanged"), object: nil)
        loadEvents(index: 0)
    }
    
    @objc func segmentChanged(_ notification: Notification) {
        guard let index = notification.userInfo?[1] as? Int else { return }
        self.index = index
        if index < 2 {
            loadEvents(index: index)
        } else {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadEvents(index: 0)
    }
    
    @IBAction func filterAction(_ sender: Any) {
        let alert = UIAlertController(title: "Sort mode", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "alphabetical", style: .default, handler: { _ in
            self.sortingMode = .alphabetical
            self.loadEvents(index: self.index)
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "time", style: .default, handler: { _ in
            self.sortingMode = .time
            self.loadEvents(index: self.index)
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventsTableViewCell
        let event = events[indexPath.row]
        cell.event = event
        cell.vc = self
        cell.eventTitle.text = event.eventTitle
        cell.eventAddress.text = event.eventAddress
        cell.eventImageView.image = nil
        setExtendedState(for: cell)
        cell.detailButton.accessibilityIdentifier = "\(indexPath.row)"
        cell.eventTime.text = shortenDateString(event.eventStart)
        cell.endTime.text = "until: \(shortenDateString(event.eventEnd))"
        cell.eventDescription.text = event.eventDescription
        cell.link.text = event.externalLink
        if cell.link.text?.isEmpty ?? true { cell.link.isHidden = true }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! EventsTableViewCell
        cell.isExpanded.toggle()
        setExtendedState(for: cell)
        tableView.reloadData()
    }
    
    private func setExtendedState(for cell: EventsTableViewCell) {
        let items = [cell.calButton, cell.rsvpButton, cell.participantsButton, cell.link, cell.eventDescription, cell.endTime]
        for item in items {
            item?.isHidden = cell.isExpanded ? false : true
        }
    }
    
    private func loadEvents(index: Int) {
        EventController.shared.fetchEvents { result in
            switch result {
            case .failure:
                print("Loading failed")
            case .success(var events):
                events = events.compactMap({ self.checkforDate(event: $0, index: index) })
                self.events = events.sorted(by: { first, second in
                    if self.sortingMode == .alphabetical {
                        return first.eventTitle ?? "" < second.eventTitle ?? ""
                    } else {
                        return self.date(from: first.eventStart ?? "") ?? Date() < self.date(from: second.eventStart ?? "") ?? Date()
                    }
                })
                self.tableView.reloadData()
            }
        }
    }
    
    private func date(from string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: string)
    }
    
    private func relativeDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: date)
    }
    
    private func shortenDateString(_ string: String?) -> String {
        guard let date = date(from: string ?? "") else { return "" }
        return relativeDateString(from: date)
    }
    
    private func isContained(for date: Date, in interval: DateInterval) -> Bool {
        interval.contains(date)
    }
    
    private func stripTime(for date: Date) -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date()))!
    }
    
    private func checkforDate(event: Event, index: Int) -> Event? {
        guard let date = date(from: event.eventStart ?? "") else { return nil }
        switch index {
        case 0:
            let interval = DateInterval(start: stripTime(for: Date()), duration: 86_400)
            return isContained(for: date, in: interval) ? event : nil
        case 1:
            let interval = DateInterval(start: Date().advanced(by: 86_400), duration: 86_400)
            return isContained(for: date, in: interval) ? event : nil
        default:
            print("custom range must be implemented")
            return nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSegue", let destination = segue.destination as? EventDetailViewController {
            let sender = sender as! UIButton
            let indexPath = Int(sender.accessibilityIdentifier ?? "")
            destination.event = events[indexPath ?? 0]
        }
    }
}

class EventsTableViewCell: UITableViewCell {
    
    //Basic
    @IBOutlet weak var eventImageView: CustomImage!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventAddress: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    //Extended
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var link: UILabel!
    @IBOutlet weak var rsvpButton: CustomButton!
    @IBOutlet weak var participantsButton: CustomButton!
    @IBOutlet weak var calButton: CustomButton!
    var isExpanded = false
    var event: Event?
    var vc: EventsTableViewController?
    
    @IBAction func rsvpTapped(_ sender: Any) {
        guard let vc = vc else { return }
        //call rsvp
        vc.tableView.reloadData()
        Helper.alert(on: vc, "We'll see you at: \(eventTitle.text ?? "")", "")
    }
    @IBAction func participantsTapped(_ sender: Any) {
        guard let vc = vc else { return }
        let participants = ["Mike", "Joe"] //get participants
        let string = participants.joined(separator: ", ")
        Helper.alert(on: vc, "Participants", string)
    }
}

enum SortingMode: String {
    case alphabetical, time
}
