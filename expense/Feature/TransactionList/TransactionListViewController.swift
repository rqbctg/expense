//
//  TransactionListViewController.swift
//  expense
//
//  Created by Raqeeb on 26/6/24.
//

import UIKit
import Combine

class TransactionListViewController: UIViewController {
    
    private let viewModel: TransactionListViewModelProtocol
    private let mainView: TransactionListView
    private var cancellable = Set<AnyCancellable>()
    
    init(_ viewModel: TransactionListViewModelProtocol = TransactionListViewModel()) {
        self.viewModel = viewModel
        self.mainView = TransactionListView(viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemBackground
        self.bind()
        
        self.title = "Record"
    }
    
}

//MARK: Action & Bind
extension TransactionListViewController {
    
    private func bind() {
        self.viewModel.transactionListViewAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                self?.transactionListAction(action: action)
            }
            .store(in: &cancellable)
    }
    
    private func transactionListAction(action: TransactionListViewAction) {
        switch action {
        case .goToTransaction:
            self.goToViewController(TransactionViewController())
        case .selectedTransaction(let value):
            let viewModel = TransactionViewModel(viewMode: .update(value: value))
            self.goToViewController(TransactionViewController(viewModel))
        }
    }
    
    private func presentTransectionViewController() {
        self.goToViewController(TransactionViewController())
    }
}

