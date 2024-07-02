//
//  TransactionListTableViewCell.swift
//  expense
//
//  Created by Raqeeb on 1/7/24.
//

import UIKit

class TransactionListTableViewCell: UITableViewCell {

    lazy var containerStackView: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .horizontal
        container.distribution = .fill
        container.spacing = 8
        return container
    }()
    
    
    lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        lbl.textColor = .black
        lbl.textAlignment = .natural
        lbl.setContentHuggingPriority(.defaultLow, for: .horizontal)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    lazy var lblAmount: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        lbl.textColor = .black
        lbl.textAlignment = .natural
        lbl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lbl.textAlignment = .right
        lbl.numberOfLines = 1
        return lbl
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        
        contentView.addSubview(iconImageView)
            NSLayoutConstraint.activate([
                iconImageView.heightAnchor.constraint(equalToConstant: 30),
                iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
                iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 30)
            ])
    
        contentView.addSubview(containerStackView)
            NSLayoutConstraint.activate([
                containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 16),
                containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -16),
                containerStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor,constant: 16),
                containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16)
            ])
            
       
            
            containerStackView.addArrangedSubview(lblTitle)
            containerStackView.addArrangedSubview(lblAmount)
        }
     
    func configure(with item: Transaction) {
        lblTitle.text = item.title
        lblAmount.text = item.transactionType.amountSign +  "\(item.amount ?? "0")" 
        iconImageView.image = item.transactionType.transactionIcon
        iconImageView.tintColor = item.transactionType.backgroundColor
        lblAmount.textColor = item.transactionType.backgroundColor
    }
}
