//
//  LayerPropertyController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/18.
//

import UIKit
import MKSwiftRes

/* position和anchorPoint
 
    https://www.jianshu.com/p/7703e6fc6191
 
    position：设置layer在父图层中的位置，以父图层的左上角为原点
    anchorPoint：决定layer的那个点会在position所指的位置，以自己的左上角为原点，
    取0-1
 
    layer显示到什么位置，是由position决定的
    layer的anchorPoint和position渲染后是重合的
 
 */

class LayerPropertyController: MKViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        layerTest()
    }
    
    private func layerTest() {
        
        let layerView = UIView.init(super: view,
                                    backgroundColor: .line_gray)
        layerView.size = .init(width: 200, height: 200)
        layerView.center = .init(x: view.width/2,
                                 y: view.height/2-MKDefine.navAllHeight)
        
        let image = UIImage.init(named: "cat")!
        /*
         iOS坐标系统：
            点：虚拟像素，即逻辑像素，在标准设备上，一个点表示一个像素，在Retina设备上
                1个点表示2*2个像素
            像素：物理像素
         */
        layerView.layer.contents = image.cgImage
        // 拉伸图片以适应图层
        layerView.layer.contentsGravity = .resizeAspect
        // 显示子区域，相对值，正确的设置介于0-1之间
        // 也可以设置大与1，此时，最外面的像素会拉伸以填充剩下的区域
        layerView.layer.contentsRect = .init(x: 0, y: 0, width: 1, height: 1)
        
        let blueLayer = CALayer.init()
        blueLayer.frame = .init(x: 50, y: 50, width: 100, height: 100)
        blueLayer.backgroundColor = UIColor.blue.cgColor
        layerView.layer.addSublayer(blueLayer)
        blueLayer.delegate = self
        blueLayer.display()
        
        /*
         UIView布局属性：
            frame： 图层外部坐标（在父试图中的位置）
            bounds：内部坐标，相对于自身的坐标
            center：相对于父视图anchorPoint所在的位置
         CALayer布局属性：
            frame、bounds同UIView的frame、bounds
            position同UIView的center
         
         其实frame并不是一个清晰的属性，是一个虚拟的属性，会根据bounds、postion和transform
         计算而来，当其中任何一个值发生变化，frame都会发生变化，改变frame也会影响他们当中的值
         */
        
        /*
        print("旋转前")
        print(layerView.frame)
        print(layerView.bounds)
        print(layerView.center)
        
        layerView.transform = CGAffineTransform.init(rotationAngle: .pi/3)
        
        print("旋转后")
        print(layerView.frame)
        print(layerView.bounds)
        print(layerView.center)
         */
 
        // layerView.layer.anchorPoint = .init(x: 0, y: 0)
        print(layerView.frame)
        print(layerView.bounds)
        print(layerView.center)
    }
}

extension LayerPropertyController: CALayerDelegate {
    /// 当需要被重新绘制时，会调用
    func display(_ layer: CALayer) {
        let circleRect = layer.bounds
        let circleLayer = CAShapeLayer.init()
        circleLayer.frame = circleRect
        circleLayer.fillColor = layer.backgroundColor
        circleLayer.lineWidth = 10
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineCap = .round
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 0.75

        let circlePath = UIBezierPath.init(roundedRect: circleRect, cornerRadius: circleRect.width/2)
        circleLayer.path = circlePath.cgPath
        layer.addSublayer(circleLayer)
    }
    
    /// 如果不实现 displayLayer方法，就会调用下面的方法
    func draw(_ layer: CALayer, in ctx: CGContext) {
        ctx.setLineWidth(10)
        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.strokeEllipse(in: layer.bounds)
    }
    
    /// 控制layer的布局
    /// 当图层的bounds发生改变，或者图层setNeedsLayout被调用，将会执行
    func layoutSublayers(of layer: CALayer) {
        
    }
}

class CusView: UIView {
    
    /*
     如果没有在view中做自定义绘制任务，就不要重写空的drawRect方法
     当视图出现在屏幕上时drawRect会被调用，其绘制的内容会被缓存起来
     知道需要被更新的时候（setNeedsDisplay）调用
     */
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}
