//
//  GravityBehaviorView.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/23.
//

import UIKit

class GravityBehaviorView: DynamicView {

    override func setup() {
        boxView.transform = CGAffineTransform.init(rotationAngle: .pi/3.5)
        let box2 = UIImageView.init(image: UIImage.init(named: "dynamic_box"))
        box2.size = .init(width: 45, height: 45)
        box2.center = .init(x: boxView.center.x+23, y: 0)
        addSubview(box2)
        // 自由落体仿真
        let gravity = UIGravityBehavior.init(items: [boxView, box2])
        // 开始仿真
        animator.addBehavior(gravity)
        
        boxView.transform = CGAffineTransform.init(rotationAngle: .pi/3)
        // 碰撞检测
        let collsion = UICollisionBehavior.init(items: [boxView, box2])
        // 回弹
        collsion.translatesReferenceBoundsIntoBoundary = true
        //
        animator.addBehavior(collsion)
    }

}
