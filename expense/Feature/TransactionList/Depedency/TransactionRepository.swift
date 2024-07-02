//
//  TransactionRepository.swift
//  expense
//
//  Created by Raqeeb on 2/7/24.
//

import Foundation
import CoreData

protocol TransactionRepositoryProtocol {
    func create(transaction: Transaction) throws
    func read(byID id: UUID) throws -> Transaction?
    func update(transaction: Transaction) throws
    func delete(byID id: UUID) throws
    var context: NSManagedObjectContext { get }
}

class TransactionRepository: TransactionRepositoryProtocol {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context(forModelName: .expanse)) {
        self.context = context
    }
    
    func create(transaction: Transaction) throws {
        context.insert(transaction)
        try context.save()
    }
    
    func read(byID id: UUID) throws -> Transaction? {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try context.fetch(fetchRequest).first
    }
    
    func update(transaction: Transaction) throws {
        try transaction.validateForUpdate()
        try self.context.save()
    }
    
    func delete(byID id: UUID) throws {
        if let transaction = try read(byID: id) {
            context.delete(transaction)
            try context.save()
        }
    }
}

