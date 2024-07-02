//
//  TransactionViewModel.swift
//  expense
//
//  Created by Raqeeb on 27/6/24.
//

import Foundation
import Combine

protocol TransactionViewModelProtocol {
    
    var transactionType: CurrentValueSubject<TransactionType,Never> { get }
    
    var transactionAmount: CurrentValueSubject<String,Never> { get }
    var transactionTitle: CurrentValueSubject<String,Never> { get }
    var transactionDate: CurrentValueSubject<String,Never> { get }
    var transactionCategory: PassthroughSubject<Category,Never> { get }
    var transactionCategoryText: CurrentValueSubject<String,Never> { get }
    var transactionNote: CurrentValueSubject<String,Never> { get }
    var selectedCategory: Category? { get set }
    
    var transactionViewMode: CurrentValueSubject<TransactionViewMode,Never> { get }
    var transactionInfoAction: PassthroughSubject<TransactionInfoViewBuilder,Never> { get set}
    var acton: PassthroughSubject<TransactionAction,Never> { get }
    var isFirstTime: Bool { get set}
    
    func changeTransactionAmountSign(_ text: String, _ amountSign: String)->String
    func createTransaction()
    func updateTransaction()
}


class TransactionViewModel: TransactionViewModelProtocol {
    var transactionViewMode = CurrentValueSubject<TransactionViewMode, Never>(.create)
    var isFirstTime: Bool = true
    var acton = PassthroughSubject<TransactionAction, Never>()
    var transactionAmount =  CurrentValueSubject<String, Never>("0")
    var transactionCategory = PassthroughSubject<Category, Never>()
    var transactionCategoryText =  CurrentValueSubject<String, Never>("")
    var transactionTitle = CurrentValueSubject<String, Never>("")
    var transactionNote = CurrentValueSubject<String, Never>("")
    var transactionDate = CurrentValueSubject<String, Never>(Date().getDateToString(format: DateFormat.default.rawValue))
    var transactionType =  CurrentValueSubject<TransactionType, Never>(.expense)
    var transactionInfoAction = PassthroughSubject<TransactionInfoViewBuilder, Never>()
    var selectedCategory: Category?
    var transaction: Transaction?
    
    private var transactionService: TransactionServiceProtocol
    
    init(
        transactionService: TransactionServiceProtocol = TransactionService(),
        viewMode: TransactionViewMode = .create
    ) {
        self.transactionViewMode.send(viewMode)
        self.transactionService = transactionService
        self.setTransactionType(viewMode: viewMode)
    }
    
    private func cleanStringToNumber(text: String)->String {
        let number = text.asNumber()
        if number.isEmpty {
            return "0"
        }
        if number.contains(".") {
            return number
        }
        return "\(number.asInt())"
    }
    
    private func setTransactionType(viewMode: TransactionViewMode) {
        switch viewMode {
        case .create:
            self.transactionType.send(.expense)
        case .update( let value):
            self.setUpdateValue(transaction: value)
        }
    }
    
    private func setUpdateValue(transaction: Transaction) {
        self.transaction = transaction
        self.transactionType.send(transaction.transactionType)
        self.transactionAmount.send(transaction.amount ?? "0")
        self.transactionTitle.send(transaction.title ?? "")
        self.selectedCategory = transaction.category
        self.transactionCategoryText.send(transaction.category?.name ?? "")
        let date = transaction.date?.getDateToString(format: DateFormat.default.rawValue) ?? ""
        self.transactionDate.send(date)
        self.transactionNote.send(transaction.note ?? "")
    }
    
    private func isTransactionDataValid()->Bool {
        
        let amount = transactionAmount.value
        
        if amount.asSignedDouble() <= 0.0 {
            ToastManager.shared.showToast(message: "Please provide transaction amount")
            return false
        }
        
        guard !self.transactionTitle.value.isEmpty else {
            ToastManager.shared.showToast(message: "Please provide transaction title")
            return false
        }
        
        guard !self.transactionDate.value.isEmpty else {
            ToastManager.shared.showToast(message: "Please provide valid date")
            return false
        }
        
        guard let _ = self.selectedCategory?.id else {
            
            ToastManager.shared.showToast(message: "Please select a category")
            return false
        }
        
        
        guard !self.transactionNote.value.isEmpty else {
            ToastManager.shared.showToast(message: "Please provide transaction note")
            return false
        }
        
        return true
    }
    
    func changeTransactionAmountSign(
        _ text: String,
        _ amountSign: String
    ) -> String {
        return amountSign + "\(self.cleanStringToNumber(text: text))"
    }
    
    func createTransaction() {
        
        if isTransactionDataValid() {
            
            do {
                try self.transactionService.createTransaction(
                    amount: transactionAmount.value.asNumber(),
                    date: transactionDate.value.getStringToDate(format: DateFormat.default.rawValue) ?? Date(),
                    title: transactionTitle.value,
                    note: transactionNote.value,
                    transactionType: transactionType.value,
                    category: self.selectedCategory!
                )
                ToastManager.shared.showToast(message: "Record created successfully")
                self.acton.send(.transactionCreated)
                
            } catch  {
                //Handle error
            }
            
            
            
        }else{
            //Handle error
        }
    }
    
    func updateTransaction() {
        if self.isTransactionDataValid() {
            guard let transaction = self.transaction else { return }
            transaction.amount = transactionAmount.value.asNumber()
            transaction.date = transactionDate.value.getStringToDate(format: DateFormat.default.rawValue) ?? Date()
            transaction.title = transactionTitle.value
            transaction.note = transactionNote.value
            transaction.transactionType = transactionType.value
            transaction.category = self.selectedCategory!
            do {
                try self.transactionService.updateTransaction(transaction)
                ToastManager.shared.showToast(message: "Record updated successfully")
                self.acton.send(.transactionUpdated)
            } catch  {
                
            }
           
        }
    }
}
