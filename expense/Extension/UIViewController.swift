//
//  UIViewController.swift
//  expense
//
//  Created by Raqeeb on 29/6/24.
//

import UIKit

extension UIViewController {
    
    func goToViewController(_ to: UIViewController) {
        if let nav = self.navigationController {
            nav.pushViewController(to, animated: true)
        }else{
            let nav = UINavigationController(rootViewController: to)
            self.present(nav, animated: true)
        }
    }
    
    func dismissViewController() {
        if let nav = self.navigationController {
            if self.isBeingPresented {
                self.dismiss(animated: true)
            }else{
                nav.popViewController(animated: true)
            }
        }else{
            self.dismiss(animated: true)
        }
    }
}
