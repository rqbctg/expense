//
//  TransactionView.swift
//  expense
//
//  Created by Raqeeb on 27/6/24.
//

import UIKit
import Combine



enum TransactionTVView {
    case amount
}

class TransactionView: UIView {
    
    var viewModel: TransactionViewModelProtocol
    private var cancellable = Set<AnyCancellable>()
    var amountSign = ""
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    lazy var containerStackView: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.distribution = .fill
        container.spacing = 8
        return container
    }()
    
    lazy var transactionTypeContainer : UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var topView : UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var transactionTypeSegment : UISegmentedControl = {
        let segment = UISegmentedControl(items: TransactionType.allValues())
        segment.tintColor = .white
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(transactionTypeSegmentValueChanged), for: .valueChanged)
        return segment
    }()
    
    lazy var transactionAmountTextField : UITextField = {
        let view = UITextField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 50)
        view.textColor = .white
        view.keyboardType = .decimalPad
        view.textAlignment = .right
        view.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.addDoneCancelToolbar()
        return view
    }()
    
    lazy var saveButtonContainer : UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var saveButtonTopBorderView : UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var saveButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    init(viewModel: TransactionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        addView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Add UI
extension TransactionView {
    private func addView() {
        
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
        
        scrollView.addSubview(containerStackView)
        let bottomConstraint =  containerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        bottomConstraint.priority = .defaultLow
        bottomConstraint.isActive = true
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        scrollView.addSubview(topView)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: topAnchor),
            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
        ])
        
        containerStackView.addArrangedSubview(transactionTypeContainer)
        transactionTypeContainer.addSubview(transactionTypeSegment)
        NSLayoutConstraint.activate([
            transactionTypeSegment.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: 16),
            transactionTypeSegment.leadingAnchor.constraint(equalTo: self.transactionTypeContainer.leadingAnchor,constant: 16),
            transactionTypeSegment.trailingAnchor.constraint(equalTo: self.transactionTypeContainer.trailingAnchor,constant: -16),
            transactionTypeSegment.heightAnchor.constraint(equalToConstant: 32),
        ])
        
        transactionTypeContainer.addSubview(transactionAmountTextField)
        NSLayoutConstraint.activate([
            transactionAmountTextField.leadingAnchor.constraint(equalTo: transactionTypeContainer.leadingAnchor, constant: 16),
            transactionAmountTextField.trailingAnchor.constraint(equalTo: transactionTypeContainer.trailingAnchor, constant: -16),
            transactionAmountTextField.topAnchor.constraint(equalTo: transactionTypeSegment.bottomAnchor, constant: 16),
            transactionAmountTextField.heightAnchor.constraint(equalToConstant: 50),
            transactionAmountTextField.bottomAnchor.constraint(equalTo: transactionTypeContainer.bottomAnchor, constant: -16)
        ])
        
        self.addAllInfoViews()
        
        addSubview(saveButtonContainer)
        NSLayoutConstraint.activate([
            saveButtonContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            saveButtonContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            saveButtonContainer.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        saveButtonContainer.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: saveButtonContainer.topAnchor,constant: 16),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,constant: 0),
            saveButton.leadingAnchor.constraint(equalTo: saveButtonContainer.leadingAnchor,constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: saveButtonContainer.trailingAnchor,constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        saveButtonContainer.addSubview(saveButtonTopBorderView)
        NSLayoutConstraint.activate([
            saveButtonTopBorderView.topAnchor.constraint(equalTo: saveButtonContainer.topAnchor,constant: 0),
            saveButtonTopBorderView.leadingAnchor.constraint(equalTo: saveButtonContainer.leadingAnchor,constant: 0),
            saveButtonTopBorderView.trailingAnchor.constraint(equalTo: saveButtonContainer.trailingAnchor,constant: 0),
            saveButtonTopBorderView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        
    }
    
    private func addAllInfoViews() {
        let infos : [TransactionInfoViewBuilder] = [.title(viewModel.transactionTitle),
                                                    .date(viewModel.transactionDate),
                                                    .category(viewModel.transactionCategoryText),
                                                    .note(viewModel.transactionNote)
        ]
        infos.forEach {
            let view = $0.getView
            view.delegate = self
            self.containerStackView.addArrangedSubview(view)
        }
        
    }
}

//MARK: Action & Bind
extension TransactionView {
    
    private func bind() {
        self.viewModel.transactionType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                self?.transactionTypeContainer.backgroundColor = type.backgroundColor
                self?.topView.backgroundColor = type.backgroundColor
                self?.amountSign = type.amountSign
                self?.changeTransactionAmountSign()
                self?.transactionTypeSegment.selectedSegmentIndex = type.rawValue
            }
            .store(in: &cancellable)
        
        viewModel.transactionViewMode
            .receive(on: DispatchQueue.main)
            .sink {[weak self] value in
                self?.setViewMode(viewMode: value)
            }
            .store(in: &cancellable)
    }
    
    private func setViewMode(viewMode: TransactionViewMode) {
        switch viewMode {
        case .update(let value):
            self.transactionAmountTextField.text = value.amount
            self.changeTransactionAmountSign()
            self.saveButton.setTitle("Update", for: .normal)
            self.saveButton.backgroundColor = .blue
            
        default:
            break
            
        }
    }
    
    @objc private func transactionTypeSegmentValueChanged() {
        let index = self.transactionTypeSegment.selectedSegmentIndex
        guard let type = TransactionType(rawValue: index) else { return }
        self.viewModel.transactionType.send(type)
    }
    
    private func changeTransactionAmountSign() {
        
        let text = self.transactionAmountTextField.text?.isEmpty ?? true ? "0" : self.transactionAmountTextField.text!
        self.transactionAmountTextField.text = self.viewModel.changeTransactionAmountSign(text, self.amountSign)
    }
    
    @objc func textFieldDidChange(textfield: UITextField) {
        self.changeTransactionAmountSign()
        guard let text = textfield.text else { return }
        viewModel.transactionAmount.send(text)
    }
    
    @objc private func saveButtonAction() {
        let viewMode = viewModel.transactionViewMode.value
        switch viewMode {
        case .create:
            viewModel.createTransaction()
        case .update:
            viewModel.updateTransaction()
        }
    }
}

extension TransactionView : TransactionInfoViewDelegate {
    func userTaped(type: TransactionInfoViewBuilder) {
        self.viewModel.transactionInfoAction.send(type)
    }
}



