//
//  AddTextView.swift
//  expense
//
//  Created by Raqeeb on 30/6/24.
//

import UIKit

class AddTextView: UIView {
    
    private let viewModel:AddTextViewModelProtocol
    
    lazy var textField : UITextField = {
        let view = UITextField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 20,weight: .regular)
        view.textAlignment = .center
        view.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.returnKeyType = .done
        view.delegate = self
        return view
    }()
    
    lazy var bottomBoarderView : UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray.withAlphaComponent(0.5)
        return view
    }()
    
    init(_ viewModel: AddTextViewModelProtocol) {
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
extension AddTextView {
    
    private func addView() {
        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: 40),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        addSubview(bottomBoarderView)
        NSLayoutConstraint.activate([
            bottomBoarderView.topAnchor.constraint(equalTo: textField.bottomAnchor,constant: 2),
            bottomBoarderView.leadingAnchor.constraint(equalTo:textField.leadingAnchor),
            bottomBoarderView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            bottomBoarderView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
    }
    
    
}

//MARK: Action & Bind
extension AddTextView {
    private func bind() {
        self.textField.text = viewModel.text.value
    }
    @objc private func textFieldDidChange() {
    }
}

extension AddTextView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.viewModel.doneAction.send(true)
        self.viewModel.text.send(textField.text ?? "")
        return true
    }
}
