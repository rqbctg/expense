//
//  AddTextViewModel.swift
//  expense
//
//  Created by Raqeeb on 30/6/24.
//

import Foundation
import Combine

protocol AddTextViewModelProtocol {
    
    var text: CurrentValueSubject<String,Never> { get }
    var doneAction: PassthroughSubject<Bool,Never> { get }
    var title: String { get set}
    
}

class AddTextViewModel : AddTextViewModelProtocol {
    var doneAction = PassthroughSubject<Bool, Never>()
    var title: String
    var text: CurrentValueSubject<String, Never>
    init(text: CurrentValueSubject<String, Never>,title: String) {
        self.text = text
        self.title = title
    }
}
