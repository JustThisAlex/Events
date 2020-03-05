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
    
    func createEvent(title: String, description: String, address: String, location: String, eventStart: String, eventEnd: String, externalLink: String?, creator: String, city: String, country: String, photo: Data? = nil, rsvpd: [String]? = nil) {
        
        let eventRepresentation = EventRepresentation(identifier: nil, eventAddress: address, eventTitle: title, eventGeolocation: nil, eventDescription: description, eventStart: eventStart, eventEnd: eventEnd, externalLink: externalLink, eventCreator: creator, eventCity: city, eventCountry: country, rsvpd: nil)
        
        apiController.post(event: eventRepresentation) { (result) in
            do {
                let representation = try result.get()
                DispatchQueue.main.async {
                    let event = Event(eventRepresentation: representation)
                    event?.photo = photo
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
    
    func updateEvent(event: Event) {
        
        guard let eventRepresentation = event.eventRepresentation else {
            NSLog("Couldnt create and event representation from event managed object")
            return
        }
        
        apiController.putEvent(event: eventRepresentation) { (result) in
            do {
                let _ = try result.get()
                DispatchQueue.main.async {
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
            apiController.deleteEvent(event: eventRepresentation) { (result) in
                do {
                    let _ = try result.get()
                    CoreDataStack.shared.mainContext.delete(event)
                    try CoreDataStack.shared.save()
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
                    } else {
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
    
    func rsvpToEvent(event: Event, completion: @escaping (Error?) -> Void = { _ in }) {
        guard let id = event.identifier else {
            NSLog("No id for event trying to rsvp to")
            completion(NSError(domain: "no id for event", code: 1, userInfo: nil))
            return
        }
        
        guard let userID = KeychainSwift.shared.get("userID") else {
            NSLog("No id for user in keychain")
            completion(NSError(domain: "no id for user in keychain", code: 1, userInfo: nil))
            return
        }
        
        apiController.rsvp(eventId: id, userId: userID) { (error) in
            if let error = error {
                NSLog("Error rspving to event: \(error)")
            }
            
            DispatchQueue.main.async {
                let username = KeychainSwift.shared.get("username") ?? userID
                event.rsvpd?.append(username)
                do {
                    try CoreDataStack.shared.save()
                    completion(nil)
                    return
                } catch {
                    NSLog("Error saving managed object context: \(error)")
                    completion(error)
                    return
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
