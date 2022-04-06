//
//  ShapLayerController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/18.
//

import UIKit
import MKSwiftRes

/*
    CAShapeLayer是一个通过矢量图形而不是bitmap来绘制的图层子类，当指定诸如颜色和线宽等属性
    用CGPath来定义想要绘制的图形，最后CAShapeLayer就自动渲染出来了
    当然，也可以用Core Graphics直接向原始的CALyer的内容中绘制一个路径
    相比直下，使用CAShapeLayer有以下一些优点：

    - 渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形会比用Core Graphics快很多
    - 高效使用内存。一个CAShapeLayer不需要像普通CALayer一样创建一个寄宿图形所以无论
      有多大，都不会占用太多的内存。
    - 不会被图层边界剪裁掉。一个CAShapeLayer可以在边界之外绘制。你的图层路径不会像在
      使用Core Graphics的普通CALayer一样被剪裁掉（如我们在第二章所见）。
    - 不会出现像素化。当你给CAShapeLayer做3D变换时，它不像一个有寄宿图的普通图层一样变得像素化。
 */

/*
    CAShapeLayer可以用来绘制所有能够通过CGPath来表示的形状。这个形状不一定要闭合，
    图层路径也不一定要不可破，事实上可以在一个图层上绘制好几个不同的形状。可以控制
    一些属性比如lineWith（线宽，用点表示单位），lineCap（线条结尾的样子），
    和lineJoin（线条之间的结合点的样子）；但是在图层层面只有一次机会设置这些属性。
    如果想用不同颜色或风格来绘制多个形状，就必须为每个形状准备一个图层
 */

class ShapLayerController: MKViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        drawMatchBoy()
        drawRoundCorner()
    }
    
    /// 火柴人
    private func drawMatchBoy() {
        
        let matchBoyView = UIView.init(super: view,backgroundColor: .table_bg)
        matchBoyView.frame = .init(x: (view.width-200)/2,
                                   y: 20,
                                   width: 200, height: 200)
        
        let path = UIBezierPath.init()
        path.move(to: .init(x: 125, y: 40))
        path.addArc(withCenter: .init(x: 100, y: 40),
                    radius: 25,
                    startAngle: 0,
                    endAngle: .pi*2,
                    clockwise: true)
        path.move(to: .init(x: 100, y: 65))
        path.addLine(to: .init(x: 100, y: 125))
        path.move(to: .init(x: 50, y: 85))
        path.addLine(to: .init(x: 150, y: 85))
        path.move(to: .init(x: 100, y: 125))
        path.addLine(to: .init(x: 60, y: 180))
        path.move(to: .init(x: 100, y: 125))
        path.addLine(to: .init(x: 140, y: 180))
        
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.lineJoin = .round
        shapeLayer.path = path.cgPath
        
        matchBoyView.layer.addSublayer(shapeLayer)
    }
    
    /// 圆角图层
    private func drawRoundCorner() {
        let tView = UIView.init(super: view,
                                backgroundColor: .random)
        tView.frame = .init(x: (view.width-200)/2,
                                   y: 300,
                                   width: 200, height: 200)
        
        let path = UIBezierPath.init(roundedRect: tView.bounds, byRoundingCorners: [.topLeft, .bottomRight], cornerRadii: .init(width: 20, height: 20))
        path.move(to: .init(x: tView.bounds.width/2+20, y: tView.bounds.height/2))
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = path.cgPath
        tView.layer.mask = shapeLayer
    }
}
