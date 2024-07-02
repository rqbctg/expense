//
//  TransactionInfoType.swift
//  expense
//
//  Created by Raqeeb on 29/6/24.
//

import Foundation
import Combine
import UIKit

enum TransactionInfoViewBuilder {
    case title(CurrentValueSubject<String, Never>)
    case note(CurrentValueSubject<String, Never>)
    case date(CurrentValueSubject<String, Never>)
    case category(CurrentValueSubject<String, Never>)
    
    var getView: TransactionInfoView {
        return TransactionInfoView(self.getViewModel)
    }
    
    var getViewModel: TransactionInfoViewModel {
        return TransactionInfoViewModel(type: self)
    }
    
    var titleLabel: String {
        switch self {
        case .title:
            return "Title"
        case .note:
            return "Note"
        case .date:
            return "Date"
        case .category:
            return "Category"
        }
    }
    
    var infoImage: UIImage? {
        switch self {
        case .title:
            return UIImage(systemName:"pencil.line")
        case .note:
            return UIImage(systemName:"note")
        case .date:
            return UIImage(systemName:"calendar.circle")
        case .category:
            return UIImage(systemName:"list.bullet.circle")
        }
    }
    
    
    var infoText: CurrentValueSubject<String, Never> {
        switch self {
        case .title(let value),
             .note(let value),
             .date(let value),
             .category(let value):
            return value
        }
    }
}
