//
//  EventRepresentation.swift
//  Events
//
//  Created by scott harris on 3/1/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

struct EventRepresentation: Codable {
    let identifier: Int32?
    let eventAddress: String
    let eventTitle: String
    let eventGeolocation: String?
    let eventDescription: String
    let eventStart: Date
    let eventEnd: Date
    let externalLink: String?
    
}
