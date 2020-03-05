//
//  EventRepresentation.swift
//  Events
//
//  Created by scott harris on 3/1/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

struct EventRepresentation: Codable {
    let identifier: String?
    let eventAddress: String
    let eventTitle: String
    let eventGeolocation: String?
    let eventDescription: String
    let eventStart: String
    let eventEnd: String
    let externalLink: String?
    let eventCreator: String
    let eventCity: String
    let eventCountry: String
    let rsvpd: [String]?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "_id"
        case eventEnd = "eventEnd"
        case eventStart = "eventStart"
        case eventAddress = "eventAddress"
        case eventTitle = "eventTitle"
        case eventDescription = "eventDescription"
        case eventGeolocation = "eventGeolocation"
        case externalLink = "externalLink"
        case eventCreator = "eventCreator"
        case eventCity = "eventCity"
        case eventCountry = "eventCountry"
        case rsvpd
        
    }
    
}
