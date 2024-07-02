//
//  CategoryViewModel.swift
//  expense
//
//  Created by Raqeeb on 30/6/24.
//

import Foundation
import Combine

protocol CategoryViewModelProtocol{
    var category: PassthroughSubject<Category,Never> { get }
    var categoryList: CurrentValueSubject<[Category],Never> { get }
    var categoryAction: PassthroughSubject<CategoryAction,Never> { get }
    var newCategoryName: CurrentValueSubject<String,Never> { get }
    func deleteItem(_ category : Category)
}

class CategoryViewModel : CategoryViewModelProtocol {
    
    var newCategoryName = CurrentValueSubject<String, Never>("")
    var categoryAction = PassthroughSubject<CategoryAction, Never>()
    var categoryList = CurrentValueSubject<[Category], Never>([])
    var category = PassthroughSubject<Category, Never>()
    
   
    
    private var transactionType: TransactionType
    private var categoryService: CategoryServiceProtocol
    private var cancellable = Set<AnyCancellable>()
    
    init(category: PassthroughSubject<Category, Never>, transactionType: TransactionType,service: CategoryServiceProtocol = CategoryService()) {
        self.category = category
        self.transactionType = transactionType
        categoryService = service
        bind()
    }
    
    private func bind() {
        newCategoryName
            .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
            .receive(on: DispatchQueue.main)
            .sink {[weak self] name in
                self?.saveCategory(name: name)
            }.store(in: &cancellable)
        categoryService.categoryList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.categoryList.send(list)
            }
            .store(in: &cancellable)
    }
    
    private func saveCategory(name: String) {
        //handle error later
        guard name.isEmpty == false else { return }
        try? categoryService.addCategory(name: name, transactionType: transactionType.rawValue)
    }
    
    func deleteItem(_ category: Category) {
        guard let id = category.id else { return }
        try? self.categoryService.deleteCategory(id: id)
    }
}
