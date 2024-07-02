//
//  CategoryTableViewCell.swift
//  expense
//
//  Created by Raqeeb on 30/6/24.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        lbl.textColor = .black
        lbl.textAlignment = .natural
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        contentView.addSubview(lblTitle)
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            lblTitle.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            lblTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            lblTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            lblTitle.heightAnchor.constraint(equalToConstant:32)
        ])
    }
    
    func configure(with item: String) {
        lblTitle.text = item
    }
}
