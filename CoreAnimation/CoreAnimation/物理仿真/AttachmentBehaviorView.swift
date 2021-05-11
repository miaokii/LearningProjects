//
//  AttachmentBehaviorView.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/23.
//

import UIKit

/*
 附着行为是描述一个视图与一个锚点或者另一个视图相连接的情况
 附着行为描述的是两点之间的连接情况，可以模拟刚性或者弹性连接
 在多个物理键设定多个UIAttachment，可以模拟多物体连接
 
 属性
    attachedBehaviorType: 连接类型（连接到锚点或视图）
    items: 连接到视图数组
    anchorPoint: 连接锚点
    length: 距离连接锚点的距离
    
    如下两个属性设置了就是弹性连接
    damping: 振幅大小
    frequency: 震动频率
 */
class AttachmentBehaviorView: DynamicView {

    private var anchorImageView: UIImageView!
    private var offsetImageView: UIImageView!
    private var attachment: UIAttachmentBehavior!
    private var segment: UISegmentedControl!
    
    override func setup() {
        
        segment = UISegmentedControl.init(items: ["刚性", "弹性"])
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentChagned), for: .valueChanged)
        addSubview(segment)
        segment.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        
        // 中心
        boxView.center = .init(x: 200, y: 200)
        
        // 附着点
        let anchorPoint = CGPoint.init(x: 200, y: 100)
        let offset = UIOffset.init(horizontal: 20, vertical: 20)
        
        // 附着行为
        attachment = UIAttachmentBehavior.init(item: boxView, offsetFromCenter: offset, attachedToAnchor: anchorPoint)
        animator.addBehavior(attachment)
        
        // 附着点附着图片
        anchorImageView = UIImageView.init(super: self,
                                           backgroundColor: .black,
                                           cornerRadius: 5)
        anchorImageView.size = .init(width: 10, height: 10)
        anchorImageView.center = anchorPoint
        
        // 参考点
        offsetImageView = UIImageView.init(super: boxView,
                                           backgroundColor: .red,
                                           cornerRadius: 5)
        offsetImageView.size = .init(width: 10, height: 10)
        let x = boxView.bounds.size.width*0.5 + offset.horizontal
        let y = boxView.bounds.size.height*0.5 + offset.vertical
        offsetImageView.center = .init(x: x, y: y)
        
        addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(panAction(pan:))))
        boxView.addObserver(self, forKeyPath: "center", options: .new, context: nil)
        
        // 添加重力效果
        let gravity = UIGravityBehavior.init(items: [boxView])
        animator.addBehavior(gravity)
        
        // 添加边界碰撞检测效果
        let collision = UICollisionBehavior.init(items: [boxView])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
    }
    
    deinit {
        boxView.removeObserver(self, forKeyPath: "center")
    }
    
    @objc private func segmentChagned() {
        if segment.selectedSegmentIndex == 1 {
            // 振幅
            attachment.damping = 0
            // 频率
            attachment.frequency = 1
        } else {
            // 振幅
            attachment.damping = 0
            // 频率
            attachment.frequency = 0
        }
    }
    
    @objc private func panAction(pan: UIPanGestureRecognizer) {
        // 获取触摸点
        let loc = pan.location(in: self)
        // 修改附着行为的附着点
        anchorImageView.center = loc
        attachment.anchorPoint = loc
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        /*
        // 上下文
        let context = UIGraphicsGetCurrentContext()
        // 起点
        context?.move(to: .init(x: anchorImageView.center.x, y: anchorImageView.center.y))
        // 路径划线的点，将轴点坐标交换，使两个点的坐标位于同一个坐标系下
        let point = self.convert(offsetImageView.center, from: boxView)
        context?.addLine(to: point)
        
        // 虚线
        context?.setLineDash(phase: 0, lengths: [8, 4])
        context?.setLineWidth(5)
        context?.drawPath(using: .stroke)
         */
        // 路径划线的点，将轴点坐标交换，使两个点的坐标位于同一个坐标系下
        let point = self.convert(offsetImageView.center, from: boxView)
        let path = UIBezierPath.init()
        path.move(to: anchorImageView.center)
        path.addLine(to: point)
        path.lineWidth = 5
        path.setLineDash([8, 6], count: 2, phase: 0)
        path.stroke()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        setNeedsDisplay()
    }
}
