//
//  CustomTimingFuncController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/22.
//

import UIKit
import MKSwiftRes

class CustomTimingFuncController: MKScrollController{
    
    private var lastView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "自定义缓冲函数"
        layoutContentSize()
    }
    
    override func addScrollSubViews() {
        let linear = curve(for: .init(name: .linear), name: "linear")
        linear.frame = .init(origin: .zero, size: linear.size)
        
        let easeIn = curve(for: .init(name: .easeIn), name: "easeIn")
        easeIn.frame = .init(origin: .init(x: 0, y: linear.frame.maxY), size: easeIn.size)
        
        let easeOut = curve(for: .init(name: .easeOut), name: "easeOut")
        easeOut.frame = .init(origin: .init(x: 0, y: easeIn.frame.maxY), size: easeOut.size)
        
        let easeInEaseOut = curve(for: .init(name: .easeInEaseOut), name: "easeInEaseOut")
        easeInEaseOut.frame = .init(origin: .init(x: 0, y: easeOut.frame.maxY), size: easeInEaseOut.size)
        
        // 钟表指针动效：缓慢开始，快速结束
        let clockPinFunction = CAMediaTimingFunction.init(controlPoints: 1, 0, 0.75, 1)
        let clock = curve(for: clockPinFunction, name: "custom clock")
        clock.frame = .init(origin: .init(x: 0, y: easeInEaseOut.frame.maxY), size: clock.size)
        
        let clockView = clockAnimationTestView()
        clockView.frame = .init(origin: .init(x: 0, y: clock.frame.maxY), size: clockView.size)
        
        lastView = clockView
    }
    
    private func curve(for function: CAMediaTimingFunction, name: String) -> UIView {
        
        let container = UIView.init(super: scrollContainer)
        container.size = .init(width: view.width, height: 250)
        let titleLabel = UILabel.init(super: container,
                                      text: name,
                                      font: .boldSystemFont(ofSize: 22))
        titleLabel.frame = .init(x: 20, y: 20, width: view.width-40, height: 30)
        
        var control1 = Array.init(repeating: Float(0), count: 2)
        function.getControlPoint(at: 1, values: &control1)
        
        var control2 = Array.init(repeating: Float(0), count: 2)
        function.getControlPoint(at: 2, values: &control2)
        
        // let controlPoint1 = function.getControlPoint1()
        // let controlPoint2 = function.getControlPoint2()
        
        let controlPoint1 = CGPoint.init(x: CGFloat(control1[0]), y: CGFloat(control1[1]))
        let controlPoint2 = CGPoint.init(x: CGFloat(control2[0]), y: CGFloat(control2[1]))
        
        let path = UIBezierPath.init()
        path.move(to: .zero)
        
        path.addCurve(to: .init(x: 1, y: 1), controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
        path.apply(CGAffineTransform.init(scaleX: 195, y: 195))
        
        let shapeView = UIView.init(super: container)
        shapeView.frame = .init(x: (view.width-195)/2, y: 45, width: view.width-195, height: 200)
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.path = path.cgPath
        shapeLayer.frame = shapeView.bounds
        shapeView.layer.addSublayer(shapeLayer)
        shapeView.layer.isGeometryFlipped = true
        return container
    }
    
    private var minutePin: UIView!
    private var secondPin: UIView!
    private var hourPin: UIView!
    private var timer: MKWTimer!

    // clock animation
    private func clockAnimationTestView() -> UIView {
        
        let container = UIView.init(super: scrollContainer)
        let titleLabel = UILabel.init(super: container,
                                      text: "自定义钟表指针缓冲动画",
                                      font: .boldSystemFont(ofSize: 22))
        titleLabel.frame = .init(x: 20, y: 20, width: view.width-40, height: 30)
        
        let clockRadius = (view.width-150)/2
        let clockView = UIView.init(super: container)
        clockView.frame = .init(x: view.width/2-clockRadius, y: titleLabel.frame.maxY+20, width: clockRadius*2, height: clockRadius*2)
        clockView.layer.cornerRadius = clockRadius
        clockView.layer.borderWidth = 1
        clockView.layer.borderColor = UIColor.black.cgColor
        container.size = .init(width: view.width, height: clockView.frame.maxY)
        
        hourPin = UIView.init(super: container,
                                  backgroundColor: .black,
                                  cornerRadius: 2)
        hourPin.size = .init(width: 4, height: clockRadius*0.4)
        hourPin.center = clockView.center
        hourPin.layer.anchorPoint = .init(x: 0.5, y: 0.8)
        
        minutePin = UIView.init(super: container,
                                    backgroundColor: .gray,
                                    cornerRadius: 2)
        minutePin.size = .init(width: 4, height: clockRadius*0.6)
        minutePin.center = clockView.center
        minutePin.layer.anchorPoint = .init(x: 0.5, y: 0.8)
        
        secondPin = UIView.init(super: container,
                                    backgroundColor: .red,
                                    cornerRadius: 1)
        secondPin.size = .init(width: 2, height: clockRadius)
        secondPin.center = clockView.center
        secondPin.layer.anchorPoint = .init(x: 0.5, y: 0.87)
        
        let dotPin = UIView.init(super: container,
                                 backgroundColor: .red,
                                 cornerRadius: 3)
        dotPin.size = .init(width: 6, height: 6)
        dotPin.center = clockView.center
        
        timer = MKWTimer.scheduledTimer(timeInterval: 1, timeClosure: { [weak self] in
            self?.tick(animated: true)
        })
        tick(animated: false)
        
        return container
    }

    @objc private func tick(animated: Bool = true) {
        // 公立日期
        let calendar = Calendar.init(identifier: .gregorian)
        let units:[Calendar.Component] = [.hour, .minute, .second]
        let components = calendar.dateComponents(.init(units), from: Date())
        guard let hours = components.hour,
              let minute = components.minute,
              let second = components.second else {
            return
        }
        
        let hoursAngle = .pi*2*CGFloat(hours)/12
        let minAngle = .pi*2*CGFloat(minute)/60
        let secondAngle = .pi*2*CGFloat(second)/60
    
        set(angle: hoursAngle, for: hourPin, animated: animated)
        set(angle: minAngle, for: minutePin, animated: animated)
        set(angle: secondAngle, for: secondPin, animated: animated)
    }
    
    private func set(angle: CGFloat, for pin: UIView, animated: Bool) {
        let transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        if animated {
            let animation = CABasicAnimation.init()
            animation.keyPath = "transform"
            animation.toValue = NSValue.init(caTransform3D: transform)
            // 1时：指针平滑移动，因为1s刷新一次
            // animation.duration = 1
            // 自定义缓冲函数
            let timingFunc = CAMediaTimingFunction.init(controlPoints: 1, 0, 0.75, 1)
            animation.timingFunction = timingFunc
            animation.delegate = self
            animation.fillMode = .removed
            animation.setValue(pin, forKey: RotateClockPinKey)
            pin.layer.add(animation, forKey: nil)
        } else {
            pin.layer.transform = transform
        }
    }
    
    private func layoutContentSize() {
        let boView = UIView(super: scrollContainer)
        boView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-20)
            make.top.equalTo(lastView.snp.bottom)
        }
    }
}

fileprivate let RotateClockPinKey = "RotateClockPinKey"
extension CustomTimingFuncController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let basicAnimation = anim as? CABasicAnimation,
           let pinView = basicAnimation.value(forKey: RotateClockPinKey) as? UIView,
           let toValue = basicAnimation.toValue as? NSValue {
            let transform = toValue.caTransform3DValue
            pinView.layer.transform = transform
        }
    }
}
