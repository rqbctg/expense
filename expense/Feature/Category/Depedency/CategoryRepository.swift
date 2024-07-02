//
//  CategoryRepository.swift
//  expense
//
//  Created by Raqeeb on 1/7/24.
//

import Foundation
import CoreData

protocol CategoryRepositoryProtocol {
    func create(category: Category) throws
    func read(id: UUID) throws -> Category?
    func delete(id: UUID) throws
    var context: NSManagedObjectContext { get }
}

class CategoryRepository:CategoryRepositoryProtocol {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context(forModelName: .expanse)) {
        self.context = context
    }
    
    func create(category: Category) throws {
        context.insert(category)
        try context.save()
    }
    
    func read(id: UUID) throws -> Category? {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try context.fetch(request).first
    }

    func delete(id: UUID) throws {
        if let categoryToDelete = try read(id: id) {
            context.delete(categoryToDelete)
            try context.save()
        }
    }
}

