//
//  DynamicView.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/23.
//

import UIKit
import MiaoKiit

class DynamicView: UIView {

    var boxView: UIImageView!
    var animator: UIDynamicAnimator!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.init(patternImage: UIImage.init(named: "dynamic_tile")!)
        
        boxView = UIImageView.init(image: UIImage.init(named: "dynamic_box"))
        boxView.size = .init(width: 80, height: 80)
        boxView.center = .init(x: MKDefine.screenWidth/2, y: 40)
        addSubview(boxView)
        
        // 仿真对象
        animator = UIDynamicAnimator.init(referenceView: self)
        
        setup()
    }
    
    func setup() {
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
