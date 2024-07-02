//
//  DatePickerView.swift
//  expense
//
//  Created by Raqeeb on 30/6/24.
//

import UIKit

class DatePickerView: UIView {
    
    private var viewModel: DatePickerViewModelProtocol
    
    lazy var datePickerView : UIDatePicker = {
        let view = UIDatePicker(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.preferredDatePickerStyle = .inline
        view.addTarget(self, action: #selector(datePicked), for: .valueChanged)
        view.datePickerMode = .date
        return view
    }()
    

    init(_ viewModel: DatePickerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        self.addView()
        self.bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Add View
extension DatePickerView {
    
    private func addView() {
        addSubview(datePickerView)
        NSLayoutConstraint.activate([
            datePickerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            datePickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            datePickerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}

//MARK: Bind & Action
extension DatePickerView {
    
    private func bind() {
        
        let date = self.viewModel.infoText.value.getStringToDate(format: DateFormat.default.rawValue)
        
        self.datePickerView.date = date ?? Date()
    }
    
    @objc private func datePicked() {
        let date = self.datePickerView.date.getDateToString(format: DateFormat.default.rawValue)
        self.viewModel.infoText.send(date)
        self.viewModel.datePickerAction.send(.datePicked)
    }
    
}
