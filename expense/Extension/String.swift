//
//  String.swift
//  expense
//
//  Created by Raqeeb on 29/6/24.
//

import Foundation

enum NumberConversionResult {
    case integer(Int)
    case double(Double)
    case invalid
}

extension String {
    func asInt()->Int{
        return Int(self) ?? 0
    }

    func asSignedDouble()->Double {
        return abs(Double(self.asNumber()) ?? 0)
    }
    
    func asNumber()->String{
        return self.filter{ $0.isNumber || $0 == "." }
    }
    
    
    func getStringToDate(format: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return  dateFormatter.date(from: self)
    }
}
