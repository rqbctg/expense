//
//  CategoryViewController.swift
//  expense
//
//  Created by Raqeeb on 30/6/24.
//

import UIKit
import Combine

class CategoryViewController: UIViewController {

    private var viewModel: CategoryViewModelProtocol
    private var mainView: CategoryView
    private var cancellable = Set<AnyCancellable>()
    
    init(_ viewModel: CategoryViewModelProtocol) {
        self.viewModel = viewModel
        self.mainView = CategoryView(viewModel)
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
        self.title = "Category"
        self.bind()
        self.addButtonToNavBar()
    }
}


//MARK: Bind & Action
extension CategoryViewController {
    
    private func bind() {
        self.viewModel.categoryAction
            .receive(on: DispatchQueue.main)
            .sink {[weak self] action in
                self?.dismissViewController()
            }
            .store(in: &cancellable)
    }
    
    private func addButtonToNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
    
    }
    
    @objc private func addTapped() {
        viewModel.newCategoryName.value = ""
        self.goToViewController(AddTextViewController(AddTextViewModel(text: viewModel.newCategoryName, title: "Category")))
    }
}
