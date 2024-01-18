//
//  VectorDrawController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/25.
//

import UIKit
import MKSwiftRes

/*
    矢量图形CoreGraphics
        任意多边形
        斜线或曲线
        文本
        渐变
 */

class VectorDrawController: MKViewController {

    private var path = UIBezierPath.init()
    private var touchDrawView = ShapeTouchDrawView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(touchDrawView)
        touchDrawView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
}

/*
 使用CoreGraphics绘制
 这种绘制方法，在每次移动手指时，都会重绘整个路径，路径与复杂，效率越低
 */
fileprivate class TouchDrawView: MKView {
    private var path = UIBezierPath.init()
    override func setup() {
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        path.lineWidth = 5
        backgroundColor = .view_l1
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }
        path.move(to: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }
        path.addLine(to: point)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.clear.setFill()
        UIColor.red.setStroke()
        path.stroke()
    }
}

/*
 使用CoreAnimation绘制，提高性能
    CAShapeLayer绘制多边形
    CATextLayer绘制文本
    CAGradientLayer绘制渐变
 */
fileprivate class ShapeTouchDrawView: MKView {
    
    private var path = UIBezierPath.init()
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override func setup() {
        let shapeLayer = layer as! CAShapeLayer
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineJoin = .round
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = 5
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }
        path.move(to: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }
        path.addLine(to: point)
        (layer as! CAShapeLayer).path = path.cgPath
    }
}
