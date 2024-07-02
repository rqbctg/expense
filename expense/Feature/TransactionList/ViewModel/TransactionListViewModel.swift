//
//  TransactionListViewModel.swift
//  expense
//
//  Created by Raqeeb on 26/6/24.
//

import Foundation
import Combine

enum TransactionListViewAction {
    case goToTransaction
    case selectedTransaction(value: Transaction)
}

protocol TransactionListViewModelProtocol {
    var transactionListViewAction: PassthroughSubject<TransactionListViewAction,Never> {get set}
    var transactionList: CurrentValueSubject<[Transaction], Never> { get set}
    func deleteItem(_ transaction : Transaction)
}

class TransactionListViewModel: TransactionListViewModelProtocol{
    
    
    var transactionList =  CurrentValueSubject<[Transaction], Never>([])
    var transactionListViewAction = PassthroughSubject<TransactionListViewAction, Never>()
    private var cancellable = Set<AnyCancellable>()
    
    private var transactionService: TransactionServiceProtocol
    
    init(transactionService: TransactionServiceProtocol = TransactionService()) {
        self.transactionService = transactionService
        self.bind()
    }
    
    private func bind() {
        transactionService.transactionList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.transactionList.send(list)
            }
            .store(in: &cancellable)
    }
    
    func deleteItem(_ transaction : Transaction) {
        guard let id = transaction.id else { return }
        try? self.transactionService.deleteTransaction(byID: id)
    }
    
}
