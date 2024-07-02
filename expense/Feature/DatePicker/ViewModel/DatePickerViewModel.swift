//
//  DatePickerViewModel.swift
//  expense
//
//  Created by Raqeeb on 30/6/24.
//

import Foundation
import Combine

protocol DatePickerViewModelProtocol {
    
    var infoText:CurrentValueSubject<String,Never> { get }
    var datePickerAction: PassthroughSubject<DatePickerAction,Never> { get }
    
}

class DatePickerViewModel: DatePickerViewModelProtocol {
    var datePickerAction = PassthroughSubject<DatePickerAction, Never>()
    
    var infoText: CurrentValueSubject<String, Never>
    
    init(infoText: CurrentValueSubject<String,Never>) {
        self.infoText = infoText

    }
    
}
