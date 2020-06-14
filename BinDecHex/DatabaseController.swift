//
//  DatabaseController.swift
//  BinDecHex
//
//  Created by Elias Hall on 1/11/20.
//  Copyright © 2020 Elias Hall. All rights reserved.
//

import Foundation
import CoreData

class DatabaseController: NSObject {
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer? = nil
    
    static func persistentStoreContainer() -> NSPersistentContainer {
        
        if( persistentContainer == nil) {
            
            
            persistentContainer = NSPersistentContainer(name: "BinDecHex")
            persistentContainer!.loadPersistentStores { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
        }
        return persistentContainer!
    }
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        if let context = persistentContainer?.viewContext {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
}
