//
//  MachObjectAttachmentView.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/23.
//

import UIKit

class MachObjectAttachmentView: DynamicView {

    private var headView: UIView!
    private var leaderAttach: UIAttachmentBehavior!
    
    override func setup() {
        var ballWidth: CGFloat = 20
        var ballHeight: CGFloat = 20
        let startX: CGFloat = 100
        
        var roundArr = [UIView]()
        
        for i in 0..<9 {
            let x = startX + CGFloat(i) * ballWidth
            let roundView = UIView.init()
            roundView.backgroundColor = UIColor.random
            roundView.layer.cornerRadius = 10
            
            // 大球
            if i == 8 {
                ballWidth = 40
                ballHeight = 40
                roundView.layer.cornerRadius = 20
                headView = roundView
            }
            
            roundView.frame = .init(x: x, y: 0, width: ballWidth, height: ballHeight)
            addSubview(roundView)
            roundArr.append(roundView)
        }
        
        // 重力行为
        let gravity = UIGravityBehavior.init(items: roundArr)
        animator.addBehavior(gravity)
        
        // 检车碰撞
        let collsition = UICollisionBehavior.init(items: roundArr)
        collsition.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collsition)
        
        for i in 0..<roundArr.count-1 {
            // 每一个元素添加一个附着行为，并添加到仿真者
            let attachment = UIAttachmentBehavior.init(item: roundArr[i], attachedTo: roundArr[i+1])
            animator.addBehavior(attachment)
        }
        
        addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(panAction(sender:))))
    }
    
    @objc private func panAction(sender: UIPanGestureRecognizer) {
        let loc = sender.location(in: self)
        switch sender.state {
        case .began:
            leaderAttach = UIAttachmentBehavior.init(item: headView, attachedToAnchor: loc)
            animator.addBehavior(leaderAttach)
        case .changed:
            leaderAttach.anchorPoint = loc
        case .ended:
            animator.removeBehavior(leaderAttach)
        default:
            break
        }
    }
}
