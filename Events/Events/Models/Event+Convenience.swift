//
//  Event+Convenience.swift
//  Events
//
//  Created by scott harris on 3/1/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation
import CoreData

extension Event {
    var eventRepresentation: EventRepresentation? {
        guard let eventStart = self.eventStart,
            let eventTitle = self.eventTitle,
            let eventAddress = self.eventAddress,
            let eventEnd = self.eventEnd,
            let description = self.eventDescription,
            let creator = self.eventCreator,
            let city = self.eventCity,
            let country = self.eventCountry
            else {  return nil }
        return EventRepresentation(identifier: self.identifier,
                                   eventAddress: eventAddress,
                                   eventTitle: eventTitle,
                                   eventGeolocation: self.eventGeolocation,
                                   eventDescription: description, eventStart: eventStart,
                                   eventEnd: eventEnd, externalLink: self.externalLink,
                                   eventCreator: creator, eventCity: city,
                                   eventCountry: country, rsvpd: nil)
    }
    convenience init(title: String, address: String, location: String,
                     description: String, start: String, end: String, externalLink: String?,
                     identifier: String?, creator: String, city: String, country: String,
                     photo: Data? = nil, rspvd: [String]? = nil,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.eventTitle = title
        self.eventAddress = address
        self.eventGeolocation = location
        self.eventDescription = description
        self.eventStart = start
        self.eventEnd = end
        self.externalLink = externalLink
        self.eventCreator = creator
        self.eventCity = city
        self.eventCountry = country
        self.photo = photo
        self.rsvpd = rspvd
    }
    @discardableResult convenience init?(eventRepresentation: EventRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        guard let identifier = eventRepresentation.identifier else {
           return nil
        }
        self.identifier = identifier
        self.eventTitle = eventRepresentation.eventTitle
        self.eventAddress = eventRepresentation.eventAddress
        self.eventDescription = eventRepresentation.eventDescription
        self.eventStart = eventRepresentation.eventStart
        self.eventEnd = eventRepresentation.eventEnd
        self.eventGeolocation = eventRepresentation.eventGeolocation
        self.externalLink = eventRepresentation.externalLink
        self.eventCreator = eventRepresentation.eventCreator
        self.eventCity = eventRepresentation.eventCity
        self.eventCountry = eventRepresentation.eventCountry
        self.rsvpd = eventRepresentation.rsvpd
    }
}
