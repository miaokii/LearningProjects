//
//  ModalViewController.swift
//  ModalView
//
//  Created by miaokii on 2021/2/3.
//

import UIKit
import MKSwiftRes

class ModalViewController: MKViewController {

    private var tagLabel: UILabel!
    var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .view_l1
        tagLabel = UILabel.init(super: view,
                                textColor: .text_l2,
                                font: .boldSystemFont(ofSize: 120))
        tagLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.85)
        }
        
        nextBtn = UIButton.themeBorderBtn(super: view, title: "present a new controller")
        nextBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-MKDefine.bottomSafeAreaHeight-MKDefine.screenHeight*0.1)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(40)
        }
        nextBtn.setClosure { [unowned self] (_) in
            self.presentNewController()
        }
        
        let cancel = UIButton.init(type: .close)
        cancel.setClosure { [unowned self] (_) in
            self.popOrDismiss()
        }
        
        if navigationController == nil {
            view.addSubview(cancel)
            cancel.snp.makeConstraints { (make) in
                make.top.equalTo(MKDefine.statusBarHeight+20)
                make.left.equalTo(20)
            }
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: cancel)
        }
    }
    
    func presentNewController() {
        
    }
    
    func set(tag: String) {
        tagLabel.text = tag
    }
}
