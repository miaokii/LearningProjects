//
//  FadeInOutBViewController.swift
//  ModalView
//
//  Created by miaokii on 2021/2/3.
//

import UIKit

class FadeInOutBViewController: ModalViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        set(tag: "B")
            
        view.backgroundColor = .random
        nextBtn.isHidden = true
    }
}
