//
//  CategoryView.swift
//  expense
//
//  Created by Raqeeb on 30/6/24.
//

import UIKit
import Combine

class CategoryView: UIView {
    
    var viewModel: CategoryViewModelProtocol
    private var cancellable = Set<AnyCancellable>()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(
            frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.clipsToBounds = false
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .singleLine
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.clipsToBounds = true
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.delegate = self
        return tableView
    }()
    
    lazy var lblNoRecord: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        lbl.textColor = .lightGray
        lbl.textAlignment = .center
        lbl.setContentHuggingPriority(.defaultLow, for: .horizontal)
        lbl.numberOfLines = 1
        lbl.text = "No category added yet"
        return lbl
    }()
    
    private var categoryDataSource: UITableViewDiffableDataSource<CategorySection,Category>?
    
    init(_ viewModel: CategoryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        self.addView()
        self.setUpDataSource()
        self.bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//MARK: Add view
extension CategoryView {
    private func addView() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        
        addSubview(lblNoRecord)
        NSLayoutConstraint.activate([
            lblNoRecord.centerXAnchor.constraint(equalTo: centerXAnchor),
            lblNoRecord.centerYAnchor.constraint(equalTo: centerYAnchor),
            lblNoRecord.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            lblNoRecord.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
        ])
    }
}


//MARK: Bind & Action
extension CategoryView {
    private func setUpDataSource() {
        
        categoryDataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else {
                fatalError("Unable to dequeue MyTableViewCell")
            }
            cell.configure(with: item.name ?? "")
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    private func applySnapShot(items: [Category]) {
        var snapshot = NSDiffableDataSourceSnapshot<CategorySection, Category>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        categoryDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
   
    
    private func bindViewModel() {
        self.viewModel.categoryList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.applySnapShot(items: items)
                self?.hideNoRecord(hide: !items.isEmpty)
            }
            .store(in: &cancellable)
    }
    private func hideNoRecord(hide: Bool) {
        self.lblNoRecord.isHidden = hide
        
    }
}


extension CategoryView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = self.categoryDataSource?.itemIdentifier(for: indexPath) else { return }
        viewModel.category.send(item)
        viewModel.categoryAction.send(.categorySelected)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            
            self.deleteTableViewItem(at: indexPath)
            complete(true)
        }
        
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
        
    }
    
    private func deleteTableViewItem(at: IndexPath) {
        guard var snapshot = self.categoryDataSource?.snapshot() else { return }
        guard let item = self.categoryDataSource?.itemIdentifier(for: at) else { return }
        snapshot.deleteItems([item])
        self.categoryDataSource?.apply(snapshot,animatingDifferences: true)
        viewModel.deleteItem(item)
    }
    
}
