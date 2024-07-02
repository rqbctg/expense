//
//  DatePickerViewController.swift
//  expense
//
//  Created by Raqeeb on 30/6/24.
//

import UIKit
import Combine

class DatePickerViewController: UIViewController {
    
    private var viewModel: DatePickerViewModelProtocol
    private var mainView: DatePickerView
    private var cancellable = Set<AnyCancellable>()
    
    init(_ viewModel: DatePickerViewModelProtocol) {
        self.viewModel = viewModel
        self.mainView = DatePickerView(viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.bind()
    }
}

//MARK: Bind & Action
extension DatePickerViewController {
    
    private func bind() {
        
        self.viewModel.datePickerAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                self?.dismissViewController()
            }
            .store(in: &cancellable)
    }
    
}
