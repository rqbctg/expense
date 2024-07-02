//
//  TransactionInfoView.swift
//  expense
//
//  Created by Raqeeb on 29/6/24.
//

import UIKit
import Combine

protocol TransactionInfoViewDelegate: AnyObject {
    func userTaped(type: TransactionInfoViewBuilder)
}

class TransactionInfoView: UIView {
    
    private let viewModel: TransactionInfoViewModelProtocol
    private var cancellable = Set<AnyCancellable>()
    
    weak var delegate: TransactionInfoViewDelegate?
    
    lazy var containerStackView: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .horizontal
        container.distribution = .fill
        container.spacing = 8
        return container
    }()
    
    lazy var bottomBorderView : UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var infoTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.textColor = .black
        lbl.textAlignment = .natural
        lbl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    lazy var infoTextLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        lbl.textColor = .black
        lbl.textAlignment = .natural
        lbl.setContentHuggingPriority(.defaultLow, for: .horizontal)
        lbl.textAlignment = .right
        lbl.numberOfLines = 1
        return lbl
    }()
    
    lazy var infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        return imageView
    }()
    
    lazy var rightChevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    init(_ viewModel: TransactionInfoViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.addTapGesture()
        self.addView()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//MARK: Add UI
extension TransactionInfoView {
    
    func addView() {
        
        addSubview(self.bottomBorderView)
        NSLayoutConstraint.activate([
            bottomBorderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBorderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBorderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBorderView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        addSubview(containerStackView)
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor,constant: 16),
            containerStackView.bottomAnchor.constraint(equalTo: bottomBorderView.topAnchor,constant: -16),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16)
        ])
        
        containerStackView.addArrangedSubview(infoImageView)
        NSLayoutConstraint.activate([
            infoImageView.heightAnchor.constraint(equalToConstant: 20),
            infoImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        containerStackView.addArrangedSubview(infoTitleLabel)
        containerStackView.addArrangedSubview(infoTextLabel)
        containerStackView.addArrangedSubview(rightChevronImageView)
        NSLayoutConstraint.activate([
            rightChevronImageView.widthAnchor.constraint(equalToConstant: 12)
        ])
    }
    
}

//MARK: Action & Bind
extension TransactionInfoView {
    
    private func bind() {
        
        viewModel.infoText
            .receive(on: DispatchQueue.main)
            .sink {[weak self] text in
                self?.infoTextLabel.text = text
            }
            .store(in: &cancellable)
        self.infoImageView.image = viewModel.type.infoImage
        self.infoTitleLabel.text = viewModel.type.titleLabel
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        self.delegate?.userTaped(type: self.viewModel.type)
    }
}


