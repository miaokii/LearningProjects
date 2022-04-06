//
//  NavViewController.swift
//  CIDetector
//
//  Created by yoctech on 2021/10/28.
//

import UIKit

class NavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.tintColor = .niceBlack
        navigationBar.isTranslucent = false
        navigationBar.prefersLargeTitles = false
        
        let appearance = navigationBar.standardAppearance.copy()
        appearance.backgroundColor = .white
        appearance.backgroundImage = UIImage.init(color: .white)
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
