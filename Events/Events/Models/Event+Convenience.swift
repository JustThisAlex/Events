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
            let geolocation = self.eventGeolocation
            else {  return nil }
        
        return EventRepresentation(identifier: self.identifier, eventAddress: eventAddress, eventTitle: eventTitle, eventGeolocation: geolocation, eventDescription: description, eventStart: eventStart, eventEnd: eventEnd, externalLink: self.externalLink)
    }
    
    convenience init(title: String, address: String, location: String, description: String, start: Date, end: Date, externalLink: String?, identifier: String?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.identifier = identifier
        self.eventTitle = title
        self.eventAddress = address
        self.eventGeolocation = location
        self.eventDescription = description
        self.eventStart = start
        self.eventEnd = end
        self.externalLink = externalLink
        
    }
    
    convenience init?(eventRepresentation: EventRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        if let id = eventRepresentation.identifier {
           self.identifier = id
        }
        
        self.eventTitle = eventRepresentation.eventTitle
        self.eventDescription = eventRepresentation.eventDescription
        self.eventStart = eventRepresentation.eventStart
        self.eventEnd = eventRepresentation.eventEnd
        self.eventGeolocation = eventRepresentation.eventGeolocation
        self.externalLink = eventRepresentation.externalLink
    }
    
}
