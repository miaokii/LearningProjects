//
//  NavigationViewController.swift
//  ModalView
//
//  Created by miaokii on 2021/1/28.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
        navigationBar.tintColor = .text_l1
        
        if #available(iOS 13, *) {
            let appearance = navigationBar.standardAppearance.copy()
            appearance.shadowColor = .lightGray
            appearance.backgroundColor = .table_bg
            appearance.backgroundEffect = nil
            appearance.titleTextAttributes = [.foregroundColor: UIColor.text_l1, .font : UIFont.boldSystemFont(ofSize: 20)]
            navigationBar.standardAppearance = appearance
        } else {
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.barTintColor = .view_l1
        }
    }
}
