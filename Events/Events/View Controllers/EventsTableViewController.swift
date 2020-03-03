//
//  EventsTableViewController.swift
//  Events
//
//  Created by Alexander Supe on 01.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.segmentChanged(_:)), name: NSNotification.Name("SegmentChanged"), object: nil)
    }
    
    @objc func segmentChanged(_ notification: Notification) {
        guard let index = notification.userInfo?[1] as? Int else { return }
        print(index)
        //Change displayed data
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Configure the cell...
        return cell
    }
}

class EventsTableViewCell: UITableViewCell {
    @IBOutlet weak var eventImageView: CustomImage!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventAddress: UILabel!
}
