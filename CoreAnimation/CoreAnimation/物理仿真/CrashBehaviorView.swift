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
        var boxs = (0..<10).map { _ in
            let size = CGFloat(arc4random()%40+20)
            let box = UIImageView.init(image: UIImage.init(named: "dynamic_box"))
            box.size = .init(width: size, height: size)
            box.center = .init(x: CGFloat(arc4random()%UInt32(MKDefine.screenWidth)), y: size/2)
            addSubview(box)
            return box
        }
        boxs.append(boxView)
        
        // 重力行为
        let gravity = UIGravityBehavior.init(items: boxs)
        animator.addBehavior(gravity)
        
        // 边缘检测
        let collision = UICollisionBehavior.init(items: boxs)
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionDelegate = self
        animator.addBehavior(collision)
        
        // 手动添加边界
//        let redPath = UIBezierPath.init(rect: redView.frame)
//        collision.addBoundary(withIdentifier: "RedBoundary" as NSCopying, for: redPath)
        
        // 弧形边界
        var arcPath = UIBezierPath.init(arcCenter: CGPoint.init(x: MKDefine.screenWidth/2, y: 250), radius: 100, startAngle: .pi, endAngle: 0, clockwise: true)
        collision.addBoundary(withIdentifier: "ArcBoundary" as NSCopying, for: arcPath)
        let arcLayer = CAShapeLayer.init()
        arcLayer.fillColor = UIColor.black.cgColor
        arcLayer.path = arcPath.cgPath
        layer.addSublayer(arcLayer)
        
        
        let leftPath = UIBezierPath()
        leftPath.move(to: .init(x: 0, y: 300))
        leftPath.addLine(to: .init(x: 200, y: 450))
        leftPath.addLine(to: .init(x:40, y: 400))
        leftPath.addLine(to: .init(x: 0, y: 300))
        leftPath.close()
        collision.addBoundary(withIdentifier: "Left Boundary" as NSCopying, for: leftPath)
        
        let leftLayer = CAShapeLayer.init()
        leftLayer.fillColor = UIColor.black.cgColor
        leftLayer.strokeColor = UIColor.red.cgColor
        leftLayer.lineWidth = 2
        leftLayer.path = leftPath.cgPath
        layer.addSublayer(leftLayer)
        
//        let arcPath = UIBezierPath.init(arcCenter: CGPoint.init(x: MKDefine.screenWidth/2, y: 250), radius: 100, startAngle: .pi, endAngle: 0, clockwise: true)
//        collision.addBoundary(withIdentifier: "ArcBoundary" as NSCopying, for: arcPath)
        
        
        // 物体属性行为
        let itemBehavior = UIDynamicItemBehavior.init(items: boxs)
        // 弹性振幅
        itemBehavior.elasticity = 0.5
        animator.addBehavior(itemBehavior)
    }

}

//
extension CrashBehaviorView: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        print("碰撞点：\(p)，id：\(identifier as? String ?? "")")
    }
}
