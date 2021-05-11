//
//  BrushDrawController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/25.
//

import UIKit
import MKSwiftRes

/*
 为了减少不必要的绘制，系统将屏幕区分为需要重绘制的区域和不需要重绘的区域，需要重绘的部分叫 脏区域
 
 当改变部分视图时，重绘整个寄宿图太浪费资源，所以可以提供脏区域的位置信息来绘制，即调用setNeedDisplayInRect方法
 */
class BrushDrawController: MKViewController {

    private var path = UIBezierPath.init()
    private var touchDrawView = RectTouchDrawView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(touchDrawView)
        touchDrawView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
}

fileprivate class TouchDrawView: MKView {
    
    private let brushsize: CGFloat = 20
    
    private var strokes = [NSValue]()
    
    override func setup() {

        backgroundColor = .view_l1
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }
        addBrushStroke(at: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }
        addBrushStroke(at: point)
    }
    
    private func addBrushStroke(at point: CGPoint) {
        strokes.append(NSValue.init(cgPoint: point))
        // 重绘制
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        for vale in strokes {
            let point = vale.cgPointValue
            let rect = CGRect.init(x: point.x - brushsize/2, y: point.y-brushsize/2, width: brushsize, height: brushsize)
            UIImage.init(named: "dot")?.draw(in: rect)
        }
    }
}

// 减少重绘制脏区域
fileprivate class RectTouchDrawView: MKView {
    
    private let brushsize: CGFloat = 20
    private var strokes = [NSValue]()
    
    override func setup() {
        backgroundColor = .view_l1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }
        addBrushStroke(at: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }
        addBrushStroke(at: point)
    }
    
    // 笔刷区域
    private func brushRect(for point: CGPoint) -> CGRect {
        .init(x: point.x - brushsize/2, y: point.y-brushsize/2, width: brushsize, height: brushsize)
    }
    
    private func addBrushStroke(at point: CGPoint) {
        strokes.append(NSValue.init(cgPoint: point))
        // 重绘制
        setNeedsDisplay(brushRect(for: point))
    }
    
    override func draw(_ rect: CGRect) {
        for vale in strokes {
            let point = vale.cgPointValue
            let brect = brushRect(for: point)
            
            if brect.intersects(rect) {
                UIImage.init(named: "dot")?.draw(in: brect)
            }
        }
    }
}
