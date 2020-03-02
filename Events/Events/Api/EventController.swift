//
//  EventController.swift
//  Events
//
//  Created by scott harris on 3/1/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation
import CoreData

class EventController {
    
    let apiController = ApiController()
    
    func createEvent(title: String, description: String, address: String, location: String, eventStart: Date, eventEnd: Date, externalLink: String?) {
        
        let id = UUID().uuidString
        
        let event = Event(title: title, address: address, location: location, description: description, start: eventStart, end: eventEnd, externalLink: externalLink, identifier: id)
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
    
    func fetchEvents() {
        apiController.fetchEvents { (error) in
            if let error = error {
                NSLog("Error fetching events from server: \(error)")
            }
            
            DispatchQueue.main.async {
                let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
                do {
                    let events = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
                    for event in events {
                        print(event.eventRepresentation)
                    }
                } catch {
                    NSLog("Error fetching events: \(error)")
                }
            }
            
        }
    }
    
}


//let title = "the title"
//let description = "the descritpion of the event"
//let address = "555 thomas ave"
//let location = "3398474.99, 49483737.77"
//let start = Date()
//let end = Date()
//let externalLink: String? = nil
//let id: Int32 = 1
//let event = Event(title: title, address: address, location: location, description: description, start: start, end: end, externalLink: externalLink, identifier: id)
//
//eventController.delete(event: event)
