//
//  AddTextViewController.swift
//  expense
//
//  Created by Raqeeb on 30/6/24.
//

import UIKit
import Combine

class AddTextViewController: UIViewController {
    
    private let viewModel: AddTextViewModelProtocol
    private let mainView: AddTextView
    private var cancellable = Set<AnyCancellable>()
    
    init(_ viewModel: AddTextViewModelProtocol) {
        self.viewModel = viewModel
        self.mainView = AddTextView(viewModel)
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
        self.title = "Add \(self.viewModel.title)"
        self.bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainView.textField.becomeFirstResponder()
    }
}

//MARK: Bind & Action
extension AddTextViewController {
    
    func bind() {
        self.viewModel.doneAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.dismissViewController()
            }
            .store(in: &cancellable)
    }
}
