//
//  SnapBehaviorView.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/23.
//

import UIKit

class SnapBehaviorView: DynamicView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first?.location(in: self) else {
            return
        }
        // 移除所有事件
        animator.removeAllBehaviors()
        // 吸附事件
        let snap = UISnapBehavior.init(item: boxView, snapTo: touchLocation)
        // 振幅，0-1，0最大，1最小
        snap.damping = 0.6
        // 开始仿真
        animator.addBehavior(snap)
        
    }
}
