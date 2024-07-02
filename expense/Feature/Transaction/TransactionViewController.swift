//
//  TransactionViewController.swift
//  expense
//
//  Created by Raqeeb on 27/6/24.
//

import UIKit
import Combine

class TransactionViewController: UIViewController {
    
    private var viewModel: TransactionViewModelProtocol
    private var mainView: TransactionView
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Add Transaction"
        self.navigationController?.presentationController?.delegate = self
        self.presentationController?.delegate = self
       
        
    }
    
    init(_ viewModel: TransactionViewModelProtocol = TransactionViewModel()) {
        self.viewModel = viewModel
        self.mainView = TransactionView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        self.bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.mainView
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = .red
        self.mainView.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.isFirstTime {
            self.mainView.transactionAmountTextField.becomeFirstResponder()
        }
        self.viewModel.isFirstTime = false
        
    }
    
}

//MARK: Bind & Action
extension TransactionViewController {
    
    private func bind() {
        self.viewModel.transactionInfoAction
            .receive(on: DispatchQueue.main)
            .sink {[weak self] infoAction in
                self?.transactionInfoAction(info: infoAction)
            }.store(in: &cancellable)
        
        viewModel.transactionCategory
            .receive(on: DispatchQueue.main)
            .sink {[weak self] category in
                self?.viewModel.selectedCategory = category
                self?.viewModel.transactionCategoryText.send(category.name ?? "")
            }.store(in: &cancellable)
        
        viewModel.acton
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                self?.transactionAction(action: action)
            }
            .store(in: &cancellable)
    }
    
    private func transactionAction(action: TransactionAction) {
        switch action {
        case .transactionCreated:
            self.dismissViewController()
        case .transactionUpdated:
            self.dismissViewController()
        }
    }
    
    private func transactionInfoAction(info: TransactionInfoViewBuilder) {
        self.view.endEditing(true)
        self.presentedViewController?.dismissViewController()
        switch info {
            
        case .title(let value),.note(let value):
            self.goToAddTextViewController(infoText: value, title: info.titleLabel)
        case .date(let value):
            self.presentDatePicker(infoText: value)
        case .category:
            self.goToCategoryViewController()
        }
    }
    
    private func goToAddTextViewController(infoText: CurrentValueSubject<String,Never>,title: String) {
        self.goToViewController(AddTextViewController(AddTextViewModel(text: infoText, title: title)))
    }
    
    private func presentDatePicker(infoText: CurrentValueSubject<String,Never>) {
        let vc = DatePickerViewController(DatePickerViewModel(infoText: infoText))
        if let sheet = vc.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        self.present(vc, animated: true)
    }
    
    private func goToCategoryViewController() {
        
        let currentTransactionType = self.viewModel.transactionType.value
        
        self.goToViewController(CategoryViewController(CategoryViewModel(category:self.viewModel.transactionCategory , transactionType: currentTransactionType)))
    }
}

extension TransactionViewController: UIAdaptivePresentationControllerDelegate{
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        
        showDismissConfirmation()
    }
    
    func showDismissConfirmation() {
        let alert = UIAlertController()
        let cancelAction = UIAlertAction(title: "Keep editing", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: "Discard Changes", style: .destructive) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(confirmAction)
        self.present(alert, animated: true)
    }

}
