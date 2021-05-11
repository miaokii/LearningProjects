//
//  PushBehaviorView.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/23.
//

import UIKit

/*
 推行为可以为一个视图施加一个作用力，该力可以是持续的，也可以是一次性的
 可以设置力的大小，方向和作用点等信息
 */
class PushBehaviorView: DynamicView {

    // 第一个触摸点位置
    private var smallView: UIView!
    // 推动行为
    private var push: UIPushBehavior!
    // 手指点击的第一个点
    private var firstPoint: CGPoint = .zero
    // 当前触摸点
    private var currentPoint: CGPoint = .zero
    
    override func setup() {
        let blueView = UIView.init(super: self,backgroundColor: .blue)
        blueView.frame = .init(x: 150, y: 300, width: 40, height: 40)
        
        smallView = UIImageView.init(super: self,
                                     cornerRadius: 5)
        smallView.backgroundColor = .black
        smallView.size = .init(width: 10, height: 10)
        // 触摸的时候显示
        smallView.isHidden = true
        
        // instantaneous: 一次推动
        // continuous: 持续推动
        push = UIPushBehavior.init(items: [boxView], mode: .instantaneous)
        // 添加推动行为
        animator.addBehavior(push)
        
        // 碰撞检测
        let collision = UICollisionBehavior.init(items: [boxView, blueView])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        // 拖拽手势
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panAction(sender:)))
        addGestureRecognizer(pan)
    }
    
    @objc private func panAction(sender: UIPanGestureRecognizer) {
        let state = sender.state
        
        switch state {
        // 开始拖动，显示起点
        case .began:
            firstPoint = sender.location(in: self)
            smallView.center = firstPoint
            smallView.isHidden = false
        // 正在拖动，
        case .changed:
            currentPoint = sender.location(in: self)
            setNeedsDisplay()
        // 拖动结束
        case .ended:
            // 计算偏移量
            let offset = CGPoint.init(x: currentPoint.x-firstPoint.x, y: currentPoint.y-firstPoint.y)
            // 角度
            var angle = atan(offset.y/offset.x)
            if currentPoint.x > firstPoint.x {
                angle = angle - .pi
            }
            push.angle = angle
            // 距离
            let distance = hypot(offset.y, offset.x)
            // 推动力度，与线的长度成正比
            push.magnitude = distance/10
            // 单次推动行为有效
            push.active = true
            // 隐藏线和起点
            firstPoint = .zero
            currentPoint = .zero
            smallView.isHidden = true
            // 重绘
            setNeedsDisplay()
        default:
            break
        }
    }
    
    override func draw(_ rect: CGRect) {
        // 上下文
        let context = UIGraphicsGetCurrentContext()
        // 对象路径
        let path = UIBezierPath.init()
        path.move(to: firstPoint)
        path.addLine(to: currentPoint)
        context?.addPath(path.cgPath)
        // 线宽
        path.lineWidth = 5
        path.lineJoinStyle = .round
        path.setLineDash([8, 4], count: 1, phase: 0)
        // 颜色
        context?.setStrokeColor(UIColor.black.cgColor)
        // 渲染
        path.stroke()
        
        
    }
}
