//
//  CategoryService.swift
//  expense
//
//  Created by Raqeeb on 1/7/24.
//

import Foundation
import CoreData
import Combine

protocol CategoryServiceProtocol{
    func addCategory(name: String, transactionType: Int) throws
    func deleteCategory(id: UUID) throws
    var categoryList: CurrentValueSubject<[Category],Never> { get }
}

class CategoryService:NSObject,CategoryServiceProtocol  {
    var categoryList = CurrentValueSubject<[Category], Never>([])
    
    private let repository: CategoryRepositoryProtocol
    
    private var fetchedResultsController: NSFetchedResultsController<Category>?
    
    init(repository: CategoryRepositoryProtocol = CategoryRepository()) {
        self.repository = repository
        super.init()
        self.setFetchController()
    }
    
    func addCategory(name: String, transactionType: Int) throws {
        let category = Category(context: repository.context)
        category.id = UUID()
        category.date = Date()
        category.name = name
        category.transactionType = transactionType
        try repository.create(category: category)
    }
    
    func deleteCategory(id: UUID) throws {
        try repository.delete(id: id)
    }
    
    private func setFetchController() {
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
     
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: repository.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        do {
            try fetchedResultsController?.performFetch()
            let list = fetchedResultsController?.fetchedObjects ?? []
            self.sendList(list: list)
        } catch {
            print("Failed to fetch categories: \(error)")
        }
        try? fetchedResultsController?.performFetch()
        
        fetchedResultsController?.delegate = self
        
    }
    
   
}

extension CategoryService:NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        let result = controller.fetchedObjects as? [Category] ?? []
        self.sendList(list: result)
    }
    
    func sendList(list: [Category]) {
        self.categoryList.send(list)
    }
}
