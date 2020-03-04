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
    static let shared = EventController()
    
    func createEvent(title: String, description: String, address: String, location: String, eventStart: String, eventEnd: String, externalLink: String?, creator: String, city: String, country: String) {
        
        let eventRepresentation = EventRepresentation(identifier: nil, eventAddress: address, eventTitle: title, eventGeolocation: nil, eventDescription: description, eventStart: eventStart, eventEnd: eventEnd, externalLink: externalLink, eventCreator: creator, eventCity: city, eventCountry: country)
        
        apiController.post(event: eventRepresentation) { (result) in
            do {
                let representation = try result.get()
                DispatchQueue.main.async {
                    let _ = Event(eventRepresentation: representation)
                    do {
                        try CoreDataStack.shared.save()
                    } catch {
                        NSLog("Error saving managed object Context: \(error)")
                    }
                }
            } catch {
                if let error = error as? NetworkError {
                    switch error {
                        case .badUrl:
                            NSLog("Bad url: \(error)")
                        case .noAuth:
                            NSLog("No auth token: \(error)")
                        case .badAuth:
                            NSLog("Bad auth token: \(error)")
                        case .otherError:
                            NSLog("other network error: \(error)")
                        case .badData:
                            NSLog("Bad data: \(error)")
                        case .noDecode:
                            NSLog("couldnt decode event representation: \(error)")
                        case .noEncode:
                            NSLog("couldnt encode event representation: \(error)")
                    case .userNotFound:
                            NSLog("Couldn't find this user")
                    }
                }
            }
        }
        
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
    
    func fetchEvents(completion: @escaping (Result<[Event], NetworkError>) -> Void) {
        apiController.fetchEvents { (error) in
            if let error = error {
                NSLog("Error fetching events from server: \(error)")
            }
            
            DispatchQueue.main.async {
                let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
                do {
                    let events = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
                    completion(.success(events))
                } catch {
                    NSLog("Error fetching events: \(error)")
                    completion(.failure(.otherError))
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
