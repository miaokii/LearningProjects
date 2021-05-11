//
//  CustomAViewController.swift
//  ModalView
//
//  Created by miaokii on 2021/2/3.
//

import UIKit

class CustomAViewController: ModalViewController {

    private var tag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set(tag: "A")
        
        
        let segmentView = UISegmentedControl.init(items: ["1", "2"])
        segmentView.selectedSegmentIndex = 0
        segmentView.addTarget(self, action: #selector(segmentChange(sender:)), for: .valueChanged)
        view.addSubview(segmentView)
        segmentView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-40)
        }
    }
    
    @objc private func segmentChange(sender: UISegmentedControl) {
        tag = sender.selectedSegmentIndex
    }
    
    override func presentNewController() {
        let vc = CustomBViewController.init()
        let presentation1 = CustomPresentationController.init(presentedViewController: vc, presenting: self)
        vc.transitioningDelegate = presentation1
        self.present(vc, animated: true, completion: nil)
    }
}
