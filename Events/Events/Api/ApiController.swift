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
    case post = "POST"
}

enum HTTPHeaderKey: String {
    case contentType = "Content-Type"
}

enum HTTPHeaderValue: String {
    case json = "application/json"
}

enum NetworkError: Error {
    case badUrl
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    case noEncode
}

class ApiController {
    typealias CompletionHandler = (Error?) -> Void
    
//    let baseURL = URL(string: "https://events-f87ab.firebaseio.com/")!
    let baseURL = URL(string: "https://evening-wildwood-75186.herokuapp.com/")!
    
    
    func signUp(user: User, completion: @escaping (Result<User, NetworkError>) -> Void) {
        let signUpURL = baseURL.appendingPathComponent("api/users/register")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderKey.contentType.rawValue)
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Network error Registering user: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                NSLog("Repsonse code was: \(response.statusCode)")
                completion(.failure(.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 201 {
                NSLog("Repsonse code was: \(response.statusCode)")
                
                guard let data = data else {
                    NSLog("Bad or no data recieved from api")
                    completion(.failure(.badData))
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let userRegistration = try decoder.decode(UserRegistration.self, from: data)
                    let newUser = User(id: userRegistration.id, user: user)
                    completion(.success(newUser))
                    
                } catch {
                   NSLog("Error decoding User Registration: \(error)")
                    completion(.failure(.noDecode))
                    return
                }
                
            }
        }.resume()
        
    }
    
    func signIn(user: User, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let signUpURL = baseURL.appendingPathComponent("api/users/login")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderKey.contentType.rawValue)
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Network error Registering user: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                NSLog("Repsonse code was: \(response.statusCode)")
                completion(.failure(.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                NSLog("Repsonse code was: \(response.statusCode)")
                
                guard let data = data else {
                    NSLog("Bad or no data recieved from api")
                    completion(.failure(.badData))
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let userLogin = try decoder.decode(AuthToken.self, from: data)
                    KeychainSwift.shared.set(userLogin.token, forKey: "AuthToken")
                    completion(.success(userLogin.token))
                    return

                } catch {
                    NSLog("Error decoding User login: \(error)")
                    completion(.failure(.noDecode))
                    return
                }
                
            }
        }.resume()
        
    }
    
    func post(event: EventRepresentation, completion: @escaping (Result<EventRepresentation, NetworkError>) -> Void) {
        let requestURL = baseURL.appendingPathComponent("api/rest/events")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderKey.contentType.rawValue)
        if let token = KeychainSwift.shared.get("AuthToken") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        } else {
            NSLog("No token in keychain")
            completion(.failure(.noAuth))
            return
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let json = try encoder.encode(event)
            let jsonString = String(data: json, encoding: .utf8)
            print(jsonString!)
            request.httpBody = json
            print(request)
        } catch {
            NSLog("Error Encoding event Representation: \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Network error PUTting event to server: \(error)")
                completion(.failure(.otherError))
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                print(response.statusCode)
            }
            
            guard let data = data else {
                NSLog("No data returned from server after posting")
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let representation = try decoder.decode(EventRepresentation.self, from: data)
                completion(.success(representation))
                return
            } catch {
                NSLog("Error decoding event representation: \(error)")
                completion(.failure(.noDecode))
                return
            }
            
        }.resume()
        
    }
    
    
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
        let eventsURL = baseURL.appendingPathComponent("api/rest/events")
        
        var request = URLRequest(url: eventsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        if let token = KeychainSwift.shared.get("AuthToken") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        } else {
            NSLog("No token in keychain")
            completion(NSError())
            return
        }
        
        
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
                let eventRepresentations = try decoder.decode([EventRepresentation].self, from: data)
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
