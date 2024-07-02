//
//  TransactionListView.swift
//  expense
//
//  Created by Raqeeb on 26/6/24.
//

import UIKit
import Combine

class TransactionListView: UIView{
    
    private var viewModel: TransactionListViewModelProtocol
    private var transactionsDataSource: UITableViewDiffableDataSource<TransactionListSection,Transaction>?
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
        tableView.register(TransactionListTableViewCell.self, forCellReuseIdentifier: TransactionListTableViewCell.identifier)
        tableView.clipsToBounds = true
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.delegate = self
        return tableView
    }()
    
    lazy var transactionButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.add, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(transactionButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var lblNoRecord: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        lbl.textColor = .lightGray
        lbl.textAlignment = .center
        lbl.setContentHuggingPriority(.defaultLow, for: .horizontal)
        lbl.numberOfLines = 1
        lbl.text = "No record created yet"
        return lbl
    }()
    
    init(_ viewModel: TransactionListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        self.addView()
        self.setUpDataSource()
        self.bindViewModel()
    }
    
    
 
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @objc private func transactionButtonAction() {
        self.viewModel.transactionListViewAction.send(.goToTransaction)
    }
}

//MARK: Add view
extension TransactionListView {
    
    private func addView() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        
        addSubview(transactionButton)
        NSLayoutConstraint.activate([
            transactionButton.heightAnchor.constraint(equalToConstant: 60),
            transactionButton.widthAnchor.constraint(equalToConstant: 60),
            transactionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            transactionButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: -16)
        ])
        transactionButton.layer.cornerRadius = 30
        
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
extension TransactionListView {
    
    private func setUpDataSource() {
        transactionsDataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionListTableViewCell.identifier, for: indexPath) as? TransactionListTableViewCell else {
                fatalError("Unable to dequeue MyTableViewCell")
            }
            cell.configure(with: item)
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    private func applySnapShot(items: [Transaction]) {
        var snapshot = NSDiffableDataSourceSnapshot<TransactionListSection, Transaction>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        transactionsDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func bindViewModel() {
        viewModel.transactionList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.applySnapShot(items: list)
                self?.hideNoRecord(hide: !list.isEmpty)
            }
            .store(in: &cancellable)
    }
    
    private func hideNoRecord(hide: Bool) {
        self.lblNoRecord.isHidden = hide
        
    }
    
}

extension TransactionListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = self.transactionsDataSource?.itemIdentifier(for: indexPath) else {return }
        viewModel.transactionListViewAction.send(.selectedTransaction(value: item))
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
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
        guard var snapshot = self.transactionsDataSource?.snapshot() else { return }
        guard let item = self.transactionsDataSource?.itemIdentifier(for: at) else { return }
        snapshot.deleteItems([item])
        self.transactionsDataSource?.apply(snapshot,animatingDifferences: true)
        viewModel.deleteItem(item)
    }
    
}
