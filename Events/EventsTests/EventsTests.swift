//
//  EventsTests.swift
//  EventsTests
//
//  Created by Alexander Supe on 05.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import XCTest
@testable import Events

class EventsTests: XCTestCase {
    
    //        func signUp(user: User, completion: @escaping (Result<User, NetworkError>) -> Void) {
    //            let signUpURL = baseURL.appendingPathComponent("api/users/register")
    //
    //            var request = URLRequest(url: signUpURL)
    //            request.httpMethod = HTTPMethod.post.rawValue
    //            request.setValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderKey.contentType.rawValue)
    //
    //            let encoder = JSONEncoder()
    //            do {
    //                let jsonData = try encoder.encode(user)
    //                request.httpBody = jsonData
    //            } catch {
    //                NSLog("Error encoding user object: \(error)")
    //                completion(.failure(.noEncode))
    //                return
    //            }
    //
    //            URLSession.shared.dataTask(with: request) { (data, response, error) in
    //                if let error = error {
    //                    NSLog("Network error Registering user: \(error)")
    //                    completion(.failure(.otherError))
    //                    return
    //                }
    //
    //                if let response = response as? HTTPURLResponse, response.statusCode != 201 {
    //                    NSLog("Repsonse code was: \(response.statusCode)")
    //                    completion(.failure(.otherError))
    //                    return
    //                }
    //
    //                if let response = response as? HTTPURLResponse, response.statusCode == 201 {
    //                    NSLog("Repsonse code was: \(response.statusCode)")
    //
    //                    guard let data = data else {
    //                        NSLog("Bad or no data recieved from api")
    //                        completion(.failure(.badData))
    //                        return
    //                    }
    //
    //                    let decoder = JSONDecoder()
    //                    do {
    //                        let user = try decoder.decode(User.self, from: data)
    //                        self.signIn(user: user) { (result) in
    //                            completion(.success(user))
    //                        }
    //
    //
    //                    } catch {
    //                       NSLog("Error decoding User Registration: \(error)")
    //                        completion(.failure(.noDecode))
    //                        return
    //                    }
    //
    //                }
    //            }.resume()
    //
    //        }
    //MARK: - 1
    func testSignUp() {
        let e1 = expectation(description: "Test")
        ApiController().signUp(user: User(id: nil, email: String(Int.random(in: 100000...9999999999)), username: nil, password: "pw", streetAddress: nil, city: nil, zipcode: nil, businessName: nil, latitude: nil, longitude: nil, country: nil)) { (result) in
            switch result {
            case .failure:
                return
            case .success:
                e1.fulfill()
            }
        }
        wait(for: [e1], timeout: 5)
    }
    //
    //        func signIn(user: User, completion: @escaping (Result<String, NetworkError>) -> Void) {
    //            let signUpURL = baseURL.appendingPathComponent("api/users/login")
    //
    //            var request = URLRequest(url: signUpURL)
    //            request.httpMethod = HTTPMethod.post.rawValue
    //            request.setValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderKey.contentType.rawValue)
    //
    //            let encoder = JSONEncoder()
    //            do {
    //                let jsonData = try encoder.encode(user)
    //                request.httpBody = jsonData
    //            } catch {
    //                NSLog("Error encoding user object: \(error)")
    //                completion(.failure(.noEncode))
    //                return
    //            }
    //
    //            URLSession.shared.dataTask(with: request) { (data, response, error) in
    //                if let error = error {
    //                    NSLog("Network error Registering user: \(error)")
    //                    completion(.failure(.otherError))
    //                    return
    //                }
    //
    //                if let response = response as? HTTPURLResponse, response.statusCode == 404 {
    //                    NSLog("User not found")
    //                    completion(.failure(.userNotFound))
    //                    return
    //                }
    //
    //                if let response = response as? HTTPURLResponse, response.statusCode != 200 {
    //                    NSLog("Repsonse code was: \(response.statusCode)")
    //                    completion(.failure(.otherError))
    //                    return
    //                }
    //
    //                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
    //                    NSLog("Repsonse code was: \(response.statusCode)")
    //
    //                    guard let data = data else {
    //                        NSLog("Bad or no data recieved from api")
    //                        completion(.failure(.badData))
    //                        return
    //                    }
    //
    //                    let decoder = JSONDecoder()
    //                    do {
    //                        let userLogin = try decoder.decode(AuthToken.self, from: data)
    //                        KeychainSwift.shared.set(userLogin.token, forKey: "token")
    //                        KeychainSwift.shared.set(userLogin.user.username ?? "", forKey: "username")
    //                        KeychainSwift.shared.set(userLogin.user.email, forKey: "email")
    //                        KeychainSwift.shared.set(userLogin.user.id ?? "", forKey: "userID")
    //                        completion(.success(userLogin.token))
    //                        return
    //
    //                    } catch {
    //                        NSLog("Error decoding User login: \(error)")
    //                        completion(.failure(.noDecode))
    //                        return
    //                    }
    //
    //                }
    //            }.resume()
    //
    //        }
    //MARK: - 2
    func testSignIn() {
        let e1 = expectation(description: "Test")
        ApiController().signIn(user: User(id: nil, email: "bernie", username: nil, password: "bernie", streetAddress: nil, city: nil, zipcode: nil, businessName: nil, latitude: nil, longitude: nil, country: nil)) { (result) in
            switch result {
            case .failure: return
            case .success: e1.fulfill()
            }
        }
        wait(for: [e1], timeout: 5)
    }
    //
    //        func update(user: User, completion: @escaping (Result<User, NetworkError>) -> Void) {
    //            guard let id = user.id else {
    //                completion(.failure(.userNotFound))
    //                return
    //            }
    //
    //            let requestURL = baseURL.appendingPathComponent("api/rest/user").appendingPathComponent(id)
    //            var request = URLRequest(url: requestURL)
    //            request.httpMethod = HTTPMethod.put.rawValue
    //            request.setValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderKey.contentType.rawValue)
    //            if let token = KeychainSwift.shared.get("token") {
    //                request.addValue(token, forHTTPHeaderField: "Authorization")
    //            } else {
    //                NSLog("No token in keychain")
    //                completion(.failure(.noAuth))
    //                return
    //            }
    //
    //            do {
    //                let encoder = JSONEncoder()
    //                let json = try encoder.encode(user)
    //                request.httpBody = json
    //            } catch {
    //                NSLog("Error encoding user: \(error)")
    //                completion(.failure(.noEncode))
    //                return
    //            }
    //
    //            URLSession.shared.dataTask(with: request) { (data, response, error) in
    //                if let error = error {
    //                    NSLog("error recieved from server while PUTting user: \(error)")
    //                    completion(.failure(.otherError))
    //                    return
    //                }
    //                if let response = response as? HTTPURLResponse, response.statusCode != 200 {
    //                    NSLog("Response code was not 200 when PUTting user, instead was: \(response.statusCode)")
    //                    completion(.failure(.badData))
    //                    return
    //                }
    //
    //                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
    //                    completion(.success(user))
    //                    return
    //                }
    //
    //            }.resume()
    //
    //
    //        }
    //MARK: - 3
    func testUpdate() {
        let e1 = expectation(description: "Test")
        ApiController().update(user: User(id: "5e6151ef2d5ce50017c178aa", email: "bernie", username: String(Int.random(in: 100000...9999999999)), password: "bernie", streetAddress: nil, city: nil, zipcode: nil, businessName: nil, latitude: nil, longitude: nil, country: nil)) { (result) in
            switch result {
            case .failure: return
            case .success: e1.fulfill()
            }
        }
        wait(for: [e1], timeout: 5)
    }
    //
    //        func post(event: EventRepresentation, completion: @escaping (Result<EventRepresentation, NetworkError>) -> Void) {
    //            let requestURL = baseURL.appendingPathComponent("api/rest/events")
    //
    //            var request = URLRequest(url: requestURL)
    //            request.httpMethod = HTTPMethod.post.rawValue
    //            request.setValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderKey.contentType.rawValue)
    //            if let token = KeychainSwift.shared.get("token") {
    //                request.addValue(token, forHTTPHeaderField: "Authorization")
    //            } else {
    //                NSLog("No token in keychain")
    //                completion(.failure(.noAuth))
    //                return
    //            }
    //
    //            do {
    //                let encoder = JSONEncoder()
    //                encoder.dateEncodingStrategy = .iso8601
    //                let json = try encoder.encode(event)
    //                let jsonString = String(data: json, encoding: .utf8)
    //                print(jsonString!)
    //                request.httpBody = json
    //                print(request)
    //            } catch {
    //                NSLog("Error Encoding event Representation: \(error)")
    //                completion(.failure(.noEncode))
    //                return
    //            }
    //
    //            URLSession.shared.dataTask(with: request) { (data, response, error) in
    //                if let error = error {
    //                    NSLog("Network error PUTting event to server: \(error)")
    //                    completion(.failure(.otherError))
    //                    return
    //                }
    //                if let response = response as? HTTPURLResponse, response.statusCode != 201 {
    //                    print(response.statusCode)
    //                }
    //
    //                guard let data = data else {
    //                    NSLog("No data returned from server after posting")
    //                    completion(.failure(.badData))
    //                    return
    //                }
    //
    //                let decoder = JSONDecoder()
    //                do {
    //                    let representation = try decoder.decode(EventRepresentation.self, from: data)
    //                    completion(.success(representation))
    //                    return
    //                } catch {
    //                    NSLog("Error decoding event representation: \(error)")
    //                    completion(.failure(.noDecode))
    //                    return
    //                }
    //
    //            }.resume()
    //
    //        }
    //MARK: - 4
    func testPost() {
        Helper.chain.set("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImJlcm5pZSIsImlhdCI6MTU4MzQzNjU1MCwiZXhwIjoxNTgzNTIyOTUwfQ.8M75pbYAX9oUDLohrC4lk9rcDKSjkv1eCMjBsGQIWmI", forKey: "token")
        let e1 = expectation(description: "Test")
        ApiController().post(event: EventRepresentation(identifier: nil, eventAddress: "test", eventTitle: "test", eventGeolocation: "test", eventDescription: "test", eventStart: "test", eventEnd: "test", externalLink: "test", eventCreator: "5e6151ef2d5ce50017c178aa", eventCity: "test", eventCountry: "test", rsvpd: nil)) { result in
            switch result {
            case .failure: return
            case .success: e1.fulfill()
            }
        }
        wait(for: [e1], timeout: 5)
    }
    
    //
    //
    //        func putEvent(event: EventRepresentation, completion: @escaping (Result<EventRepresentation, NetworkError>) -> Void) {
    //            guard let id = event.identifier else {
    //                NSLog("Tried to update an event without an id")
    //                completion(.failure(.badData))
    //                return
    //            }
    //
    //            let requestURL = baseURL.appendingPathComponent("api/rest/events").appendingPathComponent(id)
    //
    //            var request = URLRequest(url: requestURL)
    //            request.httpMethod = HTTPMethod.put.rawValue
    //            request.setValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderKey.contentType.rawValue)
    //            if let token = KeychainSwift.shared.get("token") {
    //                request.addValue(token, forHTTPHeaderField: "Authorization")
    //            } else {
    //                NSLog("No token in keychain")
    //                completion(.failure(.noAuth))
    //                return
    //            }
    //
    //            do {
    //                let encoder = JSONEncoder()
    //                encoder.dateEncodingStrategy = .iso8601
    //                let json = try encoder.encode(event)
    //                request.httpBody = json
    //            } catch {
    //                NSLog("Error Encoding event Representation: \(error)")
    //                completion(.failure(.noEncode))
    //                return
    //            }
    //
    //            URLSession.shared.dataTask(with: request) { (data, response, error) in
    //                if let error = error {
    //                    NSLog("Network error PUTting event to server: \(error)")
    //                    completion(.failure(.otherError))
    //                    return
    //                }
    //
    //                if let response = response as? HTTPURLResponse, response.statusCode != 200 {
    //                    print("Response from put event was: \(response.statusCode)")
    //                    completion(.failure(.otherError))
    //                    return
    //                }
    //
    //                guard let _ = data else {
    //                    NSLog("No data returned from server after putting")
    //                    completion(.failure(.badData))
    //                    return
    //                }
    //
    //                completion(.success(event))
    //
    //
    //
    //            }.resume()
    //
    //        }
    
    //MARK: - 5
    
    func testPut() { Helper.chain.set("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImJlcm5pZSIsImlhdCI6MTU4MzQzNjU1MCwiZXhwIjoxNTgzNTIyOTUwfQ.8M75pbYAX9oUDLohrC4lk9rcDKSjkv1eCMjBsGQIWmI", forKey: "token")
        let e1 = expectation(description: "Test")
        ApiController().putEvent(event: EventRepresentation(identifier: nil, eventAddress: "test", eventTitle: "test", eventGeolocation: "test", eventDescription: "test", eventStart: "test", eventEnd: "test", externalLink: "test", eventCreator: "5e6151ef2d5ce50017c178aa", eventCity: "test", eventCountry: "test", rsvpd: nil)) { result in
            switch result {
            case .failure: return
            case .success: e1.fulfill()
            }
        }
        wait(for: [e1], timeout: 5)
    }
    //
    //        func deleteEvent(event: EventRepresentation, completion: @escaping (Result<EventRepresentation, NetworkError>) -> Void) {
    //            guard let id = event.identifier else {
    //                NSLog("No id for event to delete")
    //                completion(.failure(.badData))
    //                return
    //            }
    //            let requestURL = baseURL.appendingPathComponent("api/rest/events").appendingPathComponent(id)
    //
    //            var request = URLRequest(url: requestURL)
    //            request.httpMethod = HTTPMethod.delete.rawValue
    //            if let token = KeychainSwift.shared.get("token") {
    //                request.addValue(token, forHTTPHeaderField: "Authorization")
    //            } else {
    //                NSLog("No token in keychain")
    //                completion(.failure(.noAuth))
    //                return
    //            }
    //
    //
    //            URLSession.shared.dataTask(with: request) { (data, response, error) in
    //                if let error = error {
    //                    NSLog("Network error PUTting event to server: \(error)")
    //                    completion(.failure(.otherError))
    //                    return
    //                }
    //
    //                if let response = response as? HTTPURLResponse, response.statusCode != 200 {
    //                    NSLog("Error deleting response, reponse code was: \(response.statusCode)")
    //                    completion(.failure(.otherError))
    //                    return
    //                }
    //
    //                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
    //                    completion(.success(event))
    //                    return
    //                }
    //
    //            }.resume()
    //
    //        }
    //MARK: - 6
    func testDelete() { Helper.chain.set("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImJlcm5pZSIsImlhdCI6MTU4MzQzNjU1MCwiZXhwIjoxNTgzNTIyOTUwfQ.8M75pbYAX9oUDLohrC4lk9rcDKSjkv1eCMjBsGQIWmI", forKey: "token")
        let e1 = expectation(description: "Test")
        ApiController().deleteEvent(event: EventRepresentation(identifier: nil, eventAddress: "test", eventTitle: "test", eventGeolocation: "test", eventDescription: "test", eventStart: "test", eventEnd: "test", externalLink: "test", eventCreator: "5e6151ef2d5ce50017c178aa", eventCity: "test", eventCountry: "test", rsvpd: nil)) { result in
            switch result {
            case .failure: return
            case .success: e1.fulfill()
            }
        }
        wait(for: [e1], timeout: 5)
    }
    
    
    //
    //        func fetchEvents(completion: @escaping CompletionHandler = { _ in }) {
    //            let eventsURL = baseURL.appendingPathComponent("api/rest/events")
    //
    //            var request = URLRequest(url: eventsURL)
    //            request.httpMethod = HTTPMethod.get.rawValue
    //            if let token = KeychainSwift.shared.get("token") {
    //                request.addValue(token, forHTTPHeaderField: "Authorization")
    //            } else {
    //                NSLog("No token in keychain")
    //                completion(NSError(domain: "token", code: 1, userInfo: nil))
    //                return
    //            }
    //
    //
    //            URLSession.shared.dataTask(with: request) { (data, response, error) in
    //                if let error = error {
    //                    NSLog("Error fetching events from server: \(error)")
    //                    completion(error)
    //                    return
    //                }
    //
    //                guard let data = data else {
    //                    NSLog("No data returned from server")
    //                    completion(NSError(domain: "bad data", code: 1, userInfo: nil))
    //                    return
    //                }
    //
    //                do {
    //                    let decoder = JSONDecoder()
    //                    decoder.dateDecodingStrategy = .iso8601
    //                    let eventRepresentations = try decoder.decode([EventRepresentation].self, from: data)
    //                    try self.updateEvents(with: eventRepresentations)
    //                    completion(nil)
    //                } catch {
    //                    NSLog("Error decoding events from server: \(error)")
    //                    completion(error)
    //                    return
    //                }
    //
    //            }.resume()
    //
    //        }
    //MARK: - 7
    func testGet() { Helper.chain.set("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImJlcm5pZSIsImlhdCI6MTU4MzQzNjU1MCwiZXhwIjoxNTgzNTIyOTUwfQ.8M75pbYAX9oUDLohrC4lk9rcDKSjkv1eCMjBsGQIWmI", forKey: "token")
        let e1 = expectation(description: "Test")
        ApiController().fetchEvents { (error) in
            if error == nil {
                e1.fulfill()
            }
        }
        wait(for: [e1], timeout: 5)
    }
    //
    //        func rsvp(eventId: String, userId: String, completion: @escaping (Error?) -> Void) {
    //
    //            let requestURL = baseURL.appendingPathComponent("api/rest/events/attend").appendingPathComponent(eventId)
    //
    //            var request = URLRequest(url: requestURL)
    //            request.httpMethod = HTTPMethod.post.rawValue
    //            request.setValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderKey.contentType.rawValue)
    //            if let token = KeychainSwift.shared.get("token") {
    //                request.addValue(token, forHTTPHeaderField: "Authorization")
    //            } else {
    //                NSLog("No token in keychain")
    //                completion(NSError(domain: "token", code: 1, userInfo: nil))
    //                return
    //            }
    //
    //            do {
    //                let encoder = JSONEncoder()
    //                let dictionary = ["_id": userId]
    //                let json = try encoder.encode(dictionary)
    //                request.httpBody = json
    //            } catch {
    //                NSLog("Error Encoding userID: \(error)")
    //                completion(error)
    //                return
    //            }
    //
    //            URLSession.shared.dataTask(with: request) { (data, response, error) in
    //                if let error = error {
    //                    NSLog("Network error PUTting event to server: \(error)")
    //                    completion(error)
    //                    return
    //                }
    //
    //                if let response = response as? HTTPURLResponse, response.statusCode != 200 {
    //                    print("Response from put event was: \(response.statusCode)")
    //                    completion(NSError(domain: "response code failure", code: response.statusCode, userInfo: nil))
    //                    return
    //                }
    //
    //                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
    //                    completion(nil)
    //                    return
    //                }
    //
    //            }.resume()
    //        }
    //MARK: - 8
    func testRsvp() { Helper.chain.set("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImJlcm5pZSIsImlhdCI6MTU4MzQzNjU1MCwiZXhwIjoxNTgzNTIyOTUwfQ.8M75pbYAX9oUDLohrC4lk9rcDKSjkv1eCMjBsGQIWmI", forKey: "token")
        let e1 = expectation(description: "Test")
        ApiController().rsvp(eventId: "", userId: "", completion: { (error) in
            if error == nil {
                e1.fulfill()
            }
        })
            wait(for: [e1], timeout: 5)
    }
    //
    //        private func updateEvents(with representations: [EventRepresentation]) throws {
    //            let eventsWithID = representations.filter { $0.identifier != nil }
    //            let identifiersToFetch = eventsWithID.compactMap { $0.identifier }
    //            let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, eventsWithID))
    //            var eventsToCreate = representationsByID
    //
    //            let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
    //            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
    //
    //            let context = CoreDataStack.shared.container.newBackgroundContext()
    //
    //            context.performAndWait {
    //                do {
    //                    let existingEvents = try context.fetch(fetchRequest)
    //
    //                    // match with existing managed events
    //                    for event in existingEvents {
    //                        guard let id = event.identifier, let representation = representationsByID[id] else { continue }
    //                        self.update(event: event, with: representation)
    //                        eventsToCreate.removeValue(forKey: id)
    //                    }
    //
    //                    // for non matched events, create managed objects
    //                    for representation in eventsToCreate.values {
    //                        Event(eventRepresentation: representation, context: context)
    //                    }
    //
    //                } catch {
    //                    NSLog("Error fetching events for id's: \(error)")
    //
    //                }
    //            }
    //
    //            try CoreDataStack.shared.save(context: context)
    //
    //        }
    //
    //        private func update(event: Event, with representation: EventRepresentation) {
    //            event.eventTitle = representation.eventTitle
    //            event.eventDescription = representation.eventDescription
    //            event.eventAddress = representation.eventAddress
    //            event.eventGeolocation = representation.eventGeolocation
    //            event.eventStart = representation.eventStart
    //            event.eventEnd = representation.eventEnd
    //            event.externalLink = representation.externalLink
    //
    //        }
    //
    //
    //    }
    
    
}
