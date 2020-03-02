//
//  ApiController.swift
//  Events
//
//  Created by scott harris on 3/1/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

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
            
            let json = try JSONEncoder().encode(representation)
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
    
    
}
