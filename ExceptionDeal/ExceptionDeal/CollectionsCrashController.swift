//
//  CollectionsCrashController.swift
//  ExceptionDeal
//
//  Created by miaokii on 2021/3/1.
//

import UIKit
import MKSwiftRes

class CollectionsCrashController: MKViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let triggerBtn = UIButton.themeBtn(super: view, title: "触发异常")
        triggerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(40)
        }
        triggerBtn.setClosure { (_) in
            self.boundsException()
        }
    }
    
    private func boundsException() {
        
    }
}
