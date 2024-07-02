//
//  TransactionService.swift
//  expense
//
//  Created by Raqeeb on 2/7/24.
//

import Foundation
import CoreData
import Combine


protocol TransactionServiceProtocol {
    func createTransaction(amount: String, date: Date, title: String, note: String, transactionType: TransactionType, category: Category) throws
    func getTransaction(byID id: UUID) throws -> Transaction?
    func updateTransaction(_ transaction: Transaction) throws
    func deleteTransaction(byID id: UUID) throws
    var transactionList: CurrentValueSubject<[Transaction],Never> { get }
    var context: NSManagedObjectContext { get }
}


class TransactionService:NSObject,TransactionServiceProtocol {
    let context: NSManagedObjectContext
    
    var transactionList = CurrentValueSubject<[Transaction], Never>([])
    
    let repository: TransactionRepositoryProtocol
    private var fetchedResultsController: NSFetchedResultsController<Transaction>?
    
    init(
        repository: TransactionRepositoryProtocol = TransactionRepository()
    ) {
        self.repository = repository
        context = repository.context
        super.init()
        self.setFetchController()
    }
    
    func createTransaction(
        amount: String,
        date: Date,
        title: String,
        note: String,
        transactionType: TransactionType,
        category: Category
    ) throws {
        let transaction = Transaction(context: repository.context)
        transaction.id = UUID()
        transaction.amount = amount
        transaction.date = date
        transaction.title = title
        transaction.note = note
        transaction.transactionType = transactionType
        transaction.category = category
        try repository.create(transaction: transaction)
    }
    
    func getTransaction(
        byID id: UUID
    ) throws -> Transaction? {
        return try repository.read(byID: id)
    }
    
    func updateTransaction(
        _ transaction: Transaction
    ) throws {
        try repository.update(transaction: transaction)
    }
    
    func deleteTransaction(
        byID id: UUID
    ) throws {
        try repository.delete(byID: id)
    }
    
    private func setFetchController() {
        
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: repository.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        do {
            try fetchedResultsController?.performFetch()
            let list = fetchedResultsController?.fetchedObjects ?? []
            self.sendList(list: list)
        } catch {
            print("Failed to fetch categories: \(error)")
        }
        try? fetchedResultsController?.performFetch()
        
        fetchedResultsController?.delegate = self
        
    }
}

extension TransactionService:NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        let result = controller.fetchedObjects as? [Transaction] ?? []
        self.sendList(list: result)
    }
    
    func sendList(list: [Transaction]) {
        self.transactionList.send(list)
    }
}


