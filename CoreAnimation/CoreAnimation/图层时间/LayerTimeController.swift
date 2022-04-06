//
//  LayerTimeController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/22.
//

import UIKit
import MiaoKiit

/*
 CAMidiaTiming协议定义了一段时间内用来控制磲时间的属性的集合
 CAMediaTiming属性：
 
 duration：单次动画时长
 repeatCount：动画重复次数
 
 repeatDuration：动画重复一个指定的时间
 autoreverses：每次间隔交替循环过程中自动回放
    以上两个属性同事设置可能会冲突，只需要指定其中的一个
 
 beginTime：指定动画开始之前的延迟时间
 speed：动画速度
 timeOffset：快进
 timeOffset和beginTime类似，但是和增加beginTime导致的延迟动画不同，
    - 增加timeOffset只是让动画快进到某一点，例如，对于一个持续1秒的动画来说，设置
      timeOffset为0.5意味着动画将从一半的地方开始。
    - 和beginTime不同的是，timeOffset并不受speed的影响。所以如果你把speed设为
      2.0，把timeOffset设置为0.5，动画将从动画最后结束的地方开始，因为1秒的动画
      实际上被缩短到了0.5秒。即使使用了timeOffset让动画从结束的地方开始，它仍然
      播放了一个完整的时长，这个动画仅仅是循环了一圈，然后从头开始播放
    - timeOffset可以手动控制动画进程，通过设置speed为0，禁用动画的自动播放，然后
      使用timeOffset回显动画序列
 fillMode：填充模式
 
 */
class LayerTimeController: MKViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureCardView()
    }
    
    private func card1Test() {
        
        let doorRect = CGRect.init(x: 50, y: 100, width: view.width-100, height: (view.width-100)*16/9)
        let doorLayer = CALayer.init()
        doorLayer.contents = UIImage.init(named: "card1")?.cgImage
        doorLayer.frame = doorRect
        view.layer.addSublayer(doorLayer)
        
        doorLayer.position = .init(x: 40, y: doorRect.minY+doorRect.height/2)
        doorLayer.anchorPoint = .init(x: 0, y: 0.5)
        
        var perspective = CATransform3DIdentity
        perspective.m34 = -1/500
        view.layer.sublayerTransform = perspective
        
        let animation = CABasicAnimation.init()
        animation.toValue = -Double.pi/2
        animation.keyPath = "transform.rotation.y"
        animation.duration = 2
        animation.repeatDuration = .infinity
        animation.autoreverses = true
        doorLayer.add(animation, forKey: nil)
    }
    
    private let doorLayer = CALayer.init()
    private func gestureCardView() {
        let doorRect = CGRect.init(x: 50, y: 100, width: view.width-100, height: (view.width-100)*16/9)
        
        doorLayer.contents = UIImage.init(named: "card1")?.cgImage
        doorLayer.frame = doorRect
        view.layer.addSublayer(doorLayer)
        
        doorLayer.position = .init(x: 40, y: doorRect.minY+doorRect.height/2)
        doorLayer.anchorPoint = .init(x: 0, y: 0.5)
        
        var perspective = CATransform3DIdentity
        perspective.m34 = -1/500
        view.layer.sublayerTransform = perspective
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panAction(sender:)))
        view.addGestureRecognizer(pan)
        
        // 暂停动画
        doorLayer.speed = 0
        let animation = CABasicAnimation.init()
        animation.toValue = -Double.pi/2
        animation.keyPath = "transform.rotation.y"
        animation.duration = 1
        doorLayer.add(animation, forKey: nil)
    }
    
    @objc private func panAction(sender: UIPanGestureRecognizer) {
        var x = sender.translation(in: view).x
        x /= 200
        // 赤绳系定,白头永偕
        var offset = doorLayer.timeOffset
        offset = min(0.999, max(0, offset-Double(x)))
        doorLayer.timeOffset = offset
        sender.setTranslation(.zero, in: view)
    }
}
