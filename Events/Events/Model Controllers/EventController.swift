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
    func createEvent(title: String, description: String,
                     address: String,
                     location: String, eventStart: String,
                     eventEnd: String,
                     externalLink: String?, creator: String,
                     city: String,
                     country: String, photo: Data? = nil,
                     rsvpd: [String]? = nil) {
        let eventRepresentation = EventRepresentation(identifier: nil,
                                                      eventAddress: address, eventTitle: title,
                                                      eventGeolocation: nil, eventDescription: description,
                                                      eventStart: eventStart, eventEnd: eventEnd,
                                                      externalLink: externalLink,
                                                      eventCreator: creator, eventCity: city,
                                                      eventCountry: country, rsvpd: nil)
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
                _ = try result.get()
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
                    _ = try result.get()
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
        guard let identifier = event.identifier else {
            NSLog("No identifier for event trying to rsvp to")
            completion(NSError(domain: "no identifier for event", code: 1, userInfo: nil))
            return
        }
        guard let userID = KeychainSwift.shared.get("userID") else {
            NSLog("No identifier for user in keychain")
            completion(NSError(domain: "no identifier for user in keychain", code: 1, userInfo: nil))
            return
        }
        apiController.rsvp(eventId: identifier, userId: userID) { (error) in
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
