//
//  Transaction+CoreDataProperties.swift
//  expense
//
//  Created by Raqeeb on 2/7/24.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var note: String?
    @NSManaged public var title: String?
    @NSManaged public var transactionTypeRaw: Int16
    @NSManaged public var category: Category?
    var transactionType: TransactionType {
        get {
            return TransactionType(rawValue: Int(transactionTypeRaw)) ?? .expense
        }set{
            
            self.transactionTypeRaw = Int16(newValue.rawValue)
        }
    }

}

extension Transaction : Identifiable {

}
