//
//  ToastManager.swift
//  expense
//
//  Created by Raqeeb on 2/7/24.
//

import UIKit

class ToastManager {
    static let shared = ToastManager()
    
    private var isToasting = false
    
    private init() {}
    
    public func showToast(
        message: String,
        font: UIFont = UIFont.systemFont(ofSize: 13),
        backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.75),
        cornerRadius: CGFloat = 8,
        textColor: UIColor = UIColor.white.withAlphaComponent(0.95),
        duration: Double = 0.50
    ) {
        
        guard let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first else { return }
        
        if isToasting {
            return
        }
        
        isToasting = true
        
        let view: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = backgroundColor
            view.layer.masksToBounds = true
            return view
        }()
        
        let label: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.textAlignment = .center
            lbl.font = font
            lbl.text = message
            lbl.numberOfLines = 2
            lbl.alpha = 1
            lbl.textColor = textColor
            return lbl
        }()
        
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        
        keyWindow.addSubview(view)
        view.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor, constant: 20).isActive = true
        view.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor, constant: -20).isActive = true
        view.topAnchor.constraint(equalTo: keyWindow.topAnchor, constant: 60).isActive = true
        
        view.transform = CGAffineTransform(translationX: 0, y: -120)
        view.layer.cornerRadius = view.frame.height / 2.0
        
        view.layoutIfNeeded()
        view.layer.cornerRadius = cornerRadius
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.25, options: [.curveEaseInOut]) {
                
                view.transform = .identity
                view.alpha = 1
                
            } completion: { _ in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
                    UIView.animate(withDuration: duration, delay: 0.25, options: [.curveEaseInOut]) {
                        
                        view.alpha = 0
                        
                    } completion: { _ in
                        view.removeFromSuperview()
                        keyWindow.layoutSubviews()
                        self.isToasting = false
                    }
                }
            }
        }
    }
}
