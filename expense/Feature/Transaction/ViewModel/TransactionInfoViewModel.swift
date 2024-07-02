//
//  TransactionInfoViewModel.swift
//  expense
//
//  Created by Raqeeb on 29/6/24.
//

import Foundation
import Combine

protocol TransactionInfoViewModelProtocol {
    var infoText: CurrentValueSubject<String,Never> { get }
    var type: TransactionInfoViewBuilder { get set}
}

class TransactionInfoViewModel: TransactionInfoViewModelProtocol {
    var type: TransactionInfoViewBuilder
    var infoText : CurrentValueSubject<String, Never>
    var infoTitle: CurrentValueSubject<String,Never>
    
    init(type: TransactionInfoViewBuilder) {
        self.type = type
        self.infoTitle = CurrentValueSubject<String,Never>(type.titleLabel)
        self.infoText = type.infoText
    }

}
