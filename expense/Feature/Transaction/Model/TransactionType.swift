//
//  TransactionType.swift
//  expense
//
//  Created by Raqeeb on 28/6/24.
//

import Foundation
import UIKit

enum TransactionType:Int,CustomStringConvertible,CaseIterable{
    case expense = 0
    case income
    
    static func allValues() -> [String] {
        return allCases.map{ $0.description }
    }
    
    public var description: String {
        switch self {
        case .income:
            return "Income"
        case .expense:
            return "Expense"
        }
    }
    var backgroundColor: UIColor {
        switch self {
        case .expense:
            return UIColor.red
        case .income:
            return UIColor.green
        }
    }
    
    var amountSign: String {
        switch self {
        case .expense:
            return "-"
        case .income:
            return "+"
        }
    }
    
    var transactionIcon : UIImage? {
        switch self {
        case .expense:
            return UIImage(systemName: "arrowshape.up.circle")
        case .income:
            return UIImage(systemName: "arrowshape.down.circle")
        }
    }
}
