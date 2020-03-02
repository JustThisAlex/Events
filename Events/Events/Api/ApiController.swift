//
//  ApiController.swift
//  Events
//
//  Created by scott harris on 3/1/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

enum HTTPHeaderKey: String {
    case contentType = "Content-Type"
}

enum HTTPHeaderValue: String {
    case json = "application/json"
}

class ApiController {
    typealias CompletionHandler = (Error?) -> Void
    
    let baseURL = URL(string: "https://events-f87ab.firebaseio.com/")!
    
    func putEvent(event: Event, completion: @escaping CompletionHandler = { _ in }) {
        let id = event.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let representation = event.eventRepresentation else {
            NSLog("Event Representation was nil")
            return
        }
        
        event.identifier = id
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving event id: \(error)")
            return
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let json = try encoder.encode(representation)
            request.httpBody = json
        } catch {
            NSLog("Error Encoding event Representation: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, repsonse, error) in
            if let error = error {
                NSLog("Network error PUTting event to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            
        }.resume()
        
    }
    
    func deleteEvent(event: EventRepresentation, completion: @escaping CompletionHandler = { _ in }) {
        guard let id = event.identifier else {
            NSLog("No id for event to delete")
            completion(NSError())
            return
        }
        let requestURL = baseURL.appendingPathComponent(String(id)).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        
        URLSession.shared.dataTask(with: request) { (data, repsonse, error) in
            if let error = error {
                NSLog("Network error PUTting event to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            
        }.resume()
        
    }
    
    func fetchEvents(completion: @escaping CompletionHandler = { _ in }) {
        let eventsURL = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: eventsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error fetching events from server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from server")
                completion(NSError())
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let eventRepresentations = Array(try decoder.decode([String: EventRepresentation].self, from: data).values)
                try self.updateEvents(with: eventRepresentations)
                completion(nil)
            } catch {
                NSLog("Error decoding events from server: \(error)")
                completion(error)
                return
            }
            
        }.resume()
 
    }
    
    private func updateEvents(with representations: [EventRepresentation]) throws {
        let eventsWithID = representations.filter { $0.identifier != nil }
        let identifiersToFetch = eventsWithID.compactMap { $0.identifier }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, eventsWithID))
        var eventsToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.performAndWait {
            do {
                let existingEvents = try context.fetch(fetchRequest)
                
                // match with existing managed events
                for event in existingEvents {
                    guard let id = event.identifier, let representation = representationsByID[id] else { continue }
                    self.update(event: event, with: representation)
                    eventsToCreate.removeValue(forKey: id)
                }
                
                // for non matched events, create managed objects
                for representation in eventsToCreate.values {
                    Event(eventRepresentation: representation, context: context)
                }
                
            } catch {
                NSLog("Error fetching events for id's: \(error)")
                
            }
        }
        
        try CoreDataStack.shared.save(context: context)
        
    }
    
    private func update(event: Event, with representation: EventRepresentation) {
        event.eventTitle = representation.eventTitle
        event.eventDescription = representation.eventDescription
        event.eventAddress = representation.eventAddress
        event.eventGeolocation = representation.eventGeolocation
        event.eventStart = representation.eventStart
        event.eventEnd = representation.eventEnd
        event.externalLink = representation.externalLink
        
    }
    
    
}
