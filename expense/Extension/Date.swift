//
//  Date.swift
//  expense
//
//  Created by Raqeeb on 30/6/24.
//

import Foundation

extension Date {
    
    func getDateToString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return  dateFormatter.string(from: self)
    }
    
    
}
