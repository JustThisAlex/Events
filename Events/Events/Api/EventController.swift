//
//  EventController.swift
//  Events
//
//  Created by scott harris on 3/1/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

class EventController {
    
    let apiController = ApiController()
    
    func createEvent(title: String, description: String, address: String, location: String, eventStart: Date, eventEnd: Date, externalLink: String?) {
        let event = Event(title: title, address: address, location: location, description: description, start: eventStart, end: eventEnd, externalLink: externalLink)
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
            return
        }
        
        apiController.putEvent(event: event)
        
    }
    
    func delete(event: Event) {
        if let eventRepresentation = event.eventRepresentation {
            apiController.deleteEvent(event: eventRepresentation) { (error) in
                if let error = error {
                    NSLog("Error deleting event from server: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    do {
                        CoreDataStack.shared.mainContext.delete(event)
                        try CoreDataStack.shared.save()
                    } catch {
                        NSLog("Error deleting event from managed object context: \(error)")
                    }
                }
                
                
            }
        }
        
    }
    
}
