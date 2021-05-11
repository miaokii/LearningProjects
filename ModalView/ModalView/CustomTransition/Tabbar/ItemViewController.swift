//
//  ItemViewController.swift
//  ModalView
//
//  Created by miaokii on 2021/2/1.
//

import UIKit
import MKSwiftRes

class ItemViewController: MKViewController {

    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel.init(super: view,
                                 text: "Controller \(index+1)",
                                 font: .boldSystemFont(ofSize: 22))
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        if index == 0 {
            view.backgroundColor = .init(0xeeeeee)
        } else  if index == 1 {
            view.backgroundColor = .init(0x00adb5)
        } else {
            view.backgroundColor = .init(0x393e46)
        }
    }    
}
