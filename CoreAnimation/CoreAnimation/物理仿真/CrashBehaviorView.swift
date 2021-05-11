//
//  CrashBehaviorView.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/23.
//

import UIKit
import MKSwiftRes

class CrashBehaviorView: DynamicView {

    private var redView: UIView!
    
    override func setup() {
        boxView.transform = CGAffineTransform.init(rotationAngle: .pi/2.6)
        
        let redView = UIView.init(super: self,
                                  backgroundColor: .red)
        redView.frame = .init(x: 20, y: MKDefine.screenHeight*0.6, width: MKDefine.screenWidth*0.45, height: 35)
        
        // 重力行为
        let gravity = UIGravityBehavior.init(items: [boxView])
        animator.addBehavior(gravity)
        
        // 边缘检测
        let collision = UICollisionBehavior.init(items: [boxView])
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionDelegate = self
        animator.addBehavior(collision)
        
        // 手动添加边界
        let redPath = UIBezierPath.init(rect: redView.frame)
        collision.addBoundary(withIdentifier: "RedBoundary" as NSCopying, for: redPath)
        
        // 弧形边界
        let arcPath = UIBezierPath.init(arcCenter: CGPoint.init(x: 200, y: 200), radius: 100, startAngle: .pi/2, endAngle: 0, clockwise: false)
        collision.addBoundary(withIdentifier: "ArcBoundary" as NSCopying, for: arcPath)
        let arcLayer = CAShapeLayer.init()
        arcLayer.fillColor = UIColor.black.cgColor
        arcLayer.path = arcPath.cgPath
        layer.addSublayer(arcLayer)
        
        // 物体属性行为
        let itemBehavior = UIDynamicItemBehavior.init(items: [boxView])
        // 弹性振幅
        itemBehavior.elasticity = 0.8
        animator.addBehavior(itemBehavior)
    }

}

//
extension CrashBehaviorView: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        print("碰撞点：\(p)，id：\(identifier as? String ?? "")")
    }
}
