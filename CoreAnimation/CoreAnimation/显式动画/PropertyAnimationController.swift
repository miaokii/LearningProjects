//
//  PropertyAnimationController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/20.
//

import UIKit
import MiaoKiit

/*
 属性动画
    更新图层的部分属性，会有隐式动画，即图层行为
    使用CAAnimation更新属性，需要设置一个新的事务
    并且禁用图层行为，否则动画会发生两次，一次是显示的
    CAAnimation，一次是隐式动画。
 
    CAAnimation可以用setValue:forKey:和valueForKey:方法来存取属性
    而且可以随意设置键值对，即使和使用的动画类所声明的属性不匹配
    通过此特性可以区分CAAnimation所添加的图层
 
 
 关键帧动画
    CAKeyframeAnimation和CABasicAnimation都是CAPropertyAnimation的子类
    都是属性动画
    CAKeyframeAnimation不需要设置不限制起始和结束的值，而是根据一连串连续的值来做动画
 */

fileprivate let AnimationBackgroundColorKey = "AnimationBackgroundColorKey"
fileprivate let RotateClockPinKey = "RotateClockPinKey"
fileprivate let KeyFrameColorKey = "KeyFrameColorKey"

class PropertyAnimationController: MKScrollController {
    
    private var lastView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContentSize()
    }
    
    override func addScrollSubViews() {
        let test1View = propertyAnimationTestView()
        test1View.frame = .init(origin: .zero, size: test1View.size)
        let test2View = clockAnimationTestView()
        test2View.frame = .init(origin: .init(x: 0, y: test1View.frame.maxY), size: test2View.size)
        let test3View = keyframeColorTestView()
        test3View.frame = .init(origin: .init(x: 0, y: test2View.frame.maxY), size: test3View.size)
        let test4View = pathKeyFrameAnimationView()
        test4View.frame = .init(origin: .init(x: 0, y: test3View.frame.maxY), size: test4View.size)
        let test5View = animationGroupView()
        test5View.frame = .init(origin: .init(x: 0, y: test4View.frame.maxY), size: test5View.size)
        lastView = test5View
    }
    
    /// 属性动画视图
    private func propertyAnimationTestView() -> UIView {
        let container = UIView.init(super: scrollContainer)
        let title1Label = UILabel.init(super: container,
                                       text: "属性动画",
                                       font: .boldSystemFont(ofSize: 22))
        title1Label.frame = .init(x: 20, y: 20, width: view.width-40, height: 30)
        
        let anView = UIView.init(super: container)
        anView.frame = .init(x: 40, y: title1Label.frame.maxY+20, width: view.width-80, height: 140)
        
        let alayer = CALayer.init()
        anView.layer.addSublayer(alayer)
        alayer.backgroundColor = UIColor.random.cgColor
        alayer.frame = anView.bounds
        
        let changeLayerColor = UIButton.themeBorder(super: container, title: "change color")
        changeLayerColor.setClosure { (_) in
            let animation = CABasicAnimation.init()
            animation.keyPath = "backgroundColor"
            animation.toValue = UIColor.random.cgColor
            animation.delegate = self
            // 设置自定义属性，区分图层
            animation.setValue(alayer, forKey: AnimationBackgroundColorKey)
            alayer.add(animation, forKey: nil)
        }
        changeLayerColor.frame = .init(x: 60, y: anView.frame.maxY+20, width: view.width-120, height: 45)
        container.size = .init(width: view.width, height: changeLayerColor.frame.maxY)
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
                                      text: "连续动画clock",
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
            animation.setValue(pin, forKey: RotateClockPinKey)
            pin.layer.add(animation, forKey: nil)
        } else {
            pin.layer.transform = transform
        }
    }
    
    /// 关键帧改变颜色动画
    private var formColor: CGColor = UIColor.blue.cgColor
    private func keyframeColorTestView() -> UIView {
        let container = UIView.init(super: scrollContainer)
        let title1Label = UILabel.init(super: container,
                                       text: "关键帧动画",
                                       font: .boldSystemFont(ofSize: 22))
        title1Label.frame = .init(x: 20, y: 20, width: view.width-40, height: 30)
        
        let anView = UIView.init(super: container)
        anView.frame = .init(x: 40, y: title1Label.frame.maxY+20, width: view.width-80, height: 140)
        
        let alayer = CALayer.init()
        anView.layer.addSublayer(alayer)
        alayer.backgroundColor = formColor
        alayer.frame = anView.bounds
        
        let changeLayerColor = UIButton.themeBorder(super: container, title: "change color")
        changeLayerColor.setClosure { (_) in
            let animation = CAKeyframeAnimation.init()
            animation.duration = 2
            animation.keyPath = "backgroundColor"
            let colors = [
                self.formColor,
                UIColor.red.cgColor,
                UIColor.purple.cgColor,
                UIColor.random.cgColor
            ]
            animation.values = colors
            
            // 计时函数/缓冲
            let fn = CAMediaTimingFunction.init(name: .easeIn)
            // 对每次动画的步骤指定不同的计时函数
            // 其数量是values数量-1，因为是values切换每一帧之间的动画速度
            animation.timingFunctions = [fn, fn, fn]
            
            self.formColor = colors.last!
            
            animation.delegate = self
            animation.setValue(alayer, forKey: KeyFrameColorKey)
            alayer.add(animation, forKey: nil)
        }
        changeLayerColor.frame = .init(x: 60, y: anView.frame.maxY+20, width: view.width-120, height: 45)
        container.size = .init(width: view.width, height: changeLayerColor.frame.maxY)
        return container
    }
    
    /// 路径关键帧动画
    private func pathKeyFrameAnimationView() -> UIView {
        let container = UIView.init(super: scrollContainer)
        container.size = .init(width: view.width, height: 340)
        
        // 动画路径
        let path = UIBezierPath.init()
        path.move(to: .init(x: 0, y: 150))
        path.addCurve(to: CGPoint.init(x: view.width, y: 150), controlPoint1: .init(x: view.width*0.25, y: 0), controlPoint2: .init(x: view.width*0.75, y: 300))
        
        // 路径图层
        let pathLayer = CAShapeLayer.init()
        pathLayer.path = path.cgPath
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.strokeColor = UIColor.red.cgColor
        pathLayer.lineWidth = 3
        container.layer.addSublayer(pathLayer)
        
        // 飞船图层
        let shipLayer = CALayer.init()
        shipLayer.frame = .init(x: 0, y: 0, width: 40, height: 40)
        shipLayer.position = .init(x: 0, y: 150)
        shipLayer.contents = UIImage.init(named: "ship")?.cgImage
        container.layer.addSublayer(shipLayer)
        
        // 动画
        let animation = CAKeyframeAnimation.init()
        animation.keyPath = "position"
        animation.duration = 4
        animation.path = path.cgPath
        shipLayer.add(animation, forKey: "shipPosition")
        // 自动控制方向
        animation.rotationMode = .rotateAuto
        
        let replay = UIButton.theme(super: container, title: "Replay")
        replay.frame = .init(x: 60, y: 300, width: view.width-120, height: 40)
        replay.setClosure { (_) in
            shipLayer.removeAnimation(forKey: "shipPosition")
            shipLayer.add(animation, forKey: "shipPosition")
        }
        
        return container
    }
    
    // 动画组
    private func animationGroupView() -> UIView {
        let container = UIView.init(super: scrollContainer)
        container.size = .init(width: view.width, height: 250)
        let titleLabel = UILabel.init(super: container,
                                      text: "动画组",
                                      font: .boldSystemFont(ofSize: 22))
        titleLabel.frame = .init(x: 20, y: 20, width: view.width-40, height: 30)
        
        let animationLayer = CALayer.init()
        animationLayer.frame = .init(x: 20, y: 70, width: view.width-40, height: 120)
        animationLayer.backgroundColor = UIColor.random.cgColor
        container.layer.addSublayer(animationLayer)
        
        let scaleAnimation = CABasicAnimation.init()
        scaleAnimation.toValue = 0.5
        scaleAnimation.keyPath = "transform.scale"
        
        let colorAnimation = CAKeyframeAnimation.init()
        colorAnimation.keyPath = "backgroundColor"
        colorAnimation.values = [
            UIColor.red.cgColor,
            UIColor.purple.cgColor,
            UIColor.random.cgColor
        ]
        
        let animationGroup = CAAnimationGroup.init()
        animationGroup.duration = 1
        animationGroup.animations = [
            scaleAnimation,
            colorAnimation]
        
        
        let replay = UIButton.theme(super: container, title: "Replay")
        replay.frame = .init(x: 60, y: 210, width: view.width-120, height: 40)
        replay.setClosure { (_) in
            animationLayer.removeAnimation(forKey: "groupAnimation")
            animationLayer.add(animationGroup, forKey: "groupAnimation")
        }
        return container
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

extension PropertyAnimationController: CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
        if let keyframeAnimation = anim as? CAKeyframeAnimation {
            if let layer = anim.value(forKey: KeyFrameColorKey) as? CALayer,
               let firstValue = keyframeAnimation.values?.first {
                let fromColor = firstValue as! CGColor
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                layer.backgroundColor = fromColor
                CATransaction.commit()
            }
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let basicAnimation = anim as? CABasicAnimation {
            if let backgroundLayer = basicAnimation.value(forKey: AnimationBackgroundColorKey) as? CALayer,
               let toValue = basicAnimation.toValue {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                let toColor = toValue as! CGColor
                backgroundLayer.backgroundColor = toColor
                CATransaction.commit()
            } else if let pinView = basicAnimation.value(forKey: RotateClockPinKey) as? UIView,
                      let toValue = basicAnimation.toValue as? NSValue {
                let transform = toValue.caTransform3DValue
                pinView.layer.transform = transform
            }
        } else if let keyframeAnimation = anim as? CAKeyframeAnimation {
            if let layer = anim.value(forKey: KeyFrameColorKey) as? CALayer,
               let lastValue = keyframeAnimation.values?.last {
                let toColor = lastValue as! CGColor
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                layer.backgroundColor = toColor
                CATransaction.commit()
            }
        }
    }
}
