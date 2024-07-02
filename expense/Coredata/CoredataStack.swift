//
//  CoredataStack.swift
//  expense
//
//  Created by Raqeeb on 1/7/24.
//

import CoreData
import Foundation

enum CoreDataStackName: String,CaseIterable{
    case expanse = "expense"
}

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}

    private var containers: [String: NSPersistentContainer] = [:]

    private func container(forModelName modelName: String) -> NSPersistentContainer {
        if let container = containers[modelName] {
            return container
        }
        
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        containers[modelName] = container
        return container
    }

    func context(forModelName modelName: CoreDataStackName = .expanse ) -> NSManagedObjectContext {
        return container(forModelName: modelName.rawValue).viewContext
    }

    func saveContext(forModelName modelName: CoreDataStackName = .expanse) {
        let context = context(forModelName: modelName)
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveAllContext() {
        for item in CoreDataStackName.allCases {
            self.saveContext(forModelName: item)
        }
    }
}

