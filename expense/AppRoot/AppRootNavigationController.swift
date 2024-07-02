//
//  AppRootNavigationController.swift
//  expense
//
//  Created by Raqeeb on 2/7/24.
//

import UIKit

class AppRootNavigationController: UINavigationController {
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = .red
        // Do any additional setup after loading the view.
    }
}
