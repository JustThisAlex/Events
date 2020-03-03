//
//  CoreDataStack.swift
//  Events
//
//  Created by scott harris on 3/1/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "Events")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                NSLog("Error saving managed object context: \(saveError)")
                error = saveError
            }
        }
        if let error = error { throw error }
    }
    
}
