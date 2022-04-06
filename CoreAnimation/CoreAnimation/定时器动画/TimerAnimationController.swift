//
//  TimerAnimationController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/23.
//

import UIKit
import MiaoKiit

/*
 NSTimer：
 iOS上的每个线程都管理了一个NSRunloop，通过一个循环来完成一些任务列表。但是对主线程，这些任务包含如下几项：
    - 处理触摸事件
    - 发送和接受网络数据包
    - 执行使用gcd的代码
    - 处理计时器行为
    - 屏幕重绘
 当设置一个NSTimer，他会被插入到当前任务列表中，然后直到指定时间过去之后才会被执行。但是何时启动定时器并没有一个时间上限，而且它只会在列表中上一个任务完成之后开始执行。这通常会导致有几毫秒的延迟，但是如果上一个任务过了很久才完成就会导致延迟很长一段时间

 屏幕重绘的频率是一秒钟六十次，但是和定时器行为一样，如果列表中上一个执行了很长时间，它也会延迟。这些延迟都是一个随机值，于是就不能保证定时器精准地一秒钟执行六十次。有时候发生在屏幕重绘之后，这就会使得更新屏幕会有个延迟，看起来就是动画卡壳了。有时候定时器会在屏幕更新的时候执行两次，于是动画看起来就跳动了。

 通过一些途径来优化：
    - 使用CADisplayLink让更新频率严格控制在每次屏幕刷新之后
    - 基于真实帧的持续时间而不是假设的更新频率来做动画
    - 调整动画计时器的run loop模式，这样就不会被别的事件干扰
 
 */

class TimerAnimationController: MKScrollController {
    
    var lastView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContentSize()
    }
    
    override func addScrollSubViews() {
        let timerView = dropDownballView()
        timerView.frame = .init(origin: .zero, size: timerView.size)
        
        lastView = timerView
    }
    
    private var ballView: UIImageView!
    private var timer: MKWTimer!
    private var duration: TimeInterval = 1
    private var timeOffset: TimeInterval = 0
    private var fromValue: CGPoint = .zero
    private var toValue: CGPoint = .zero
    private var link: CADisplayLink!
    
    private func dropDownballView() -> UIView {
        let container = ContainerView.init(super: scrollContainer)
        container.size = .init(width: view.width, height: 400)
        
        let ballContainer = UIView.init(super: container)
        ballContainer.frame = .init(x: 0, y: 20, width: view.width, height: 240)
        
        ballView = UIImageView.init(super: ballView, image: UIImage.init(named: "ball"))
        ballView.size = .init(width: 40, height: 40)
        ballView.center = .init(x: view.width/2, y: 30)
        
        let timerDropBtn = UIButton.themeBorder(super: container, title: "Timer Drop Down")
        timerDropBtn.frame = .init(x: 60, y: ballContainer.frame.maxY+20, width: view.width-120, height: 40)
        timerDropBtn.setClosure { (_) in
            self.animate(nsTimer: true)
        }
        
        let linkDropBtn = UIButton.themeBorder(super: container, title: "CADisplayLink Drop Down")
        linkDropBtn.frame = .init(x: 60, y: timerDropBtn.frame.maxY+20, width: view.width-120, height: 40)
        linkDropBtn.setClosure { (_) in
            self.animate(nsTimer: false)
        }
        return container
    }
    
    private func animate(nsTimer: Bool) {
        ballView.center = .init(x: view.width/2, y: 30)
        duration = 1
        timeOffset = 0
        fromValue = .init(x: view.width/2, y: 30)
        toValue = .init(x: view.width/2, y: ballView.superview!.height-20)
        
        if nsTimer {
            if timer != nil {
                timer.invalidate()
            }
            
            let stepFunc: ()-> Void = { [unowned self] in
                // timeOffset
                timeOffset = .minimum(timeOffset+1/60, duration)
                // normalized time offset 0-1
                var time = timeOffset/duration
                time = bounceEaseOut(t: time)
                // interpolate position
                let position = interpolate(from: fromValue, to: toValue, time: time)
                
                ballView.center = position
                if timeOffset >= duration {
                    timer.invalidate()
                    timer = nil
                }
            }
            
            timer = MKWTimer.scheduledTimer(timeInterval: 1/60,
                                            repeats: true,
                                            timeClosure: stepFunc)
        } else {
            if link != nil {
                link.invalidate()
            }
            
            link = CADisplayLink.init(target: self, selector: #selector(displayLinkAction))
            link.add(to: .main, forMode: .common)
        }
    }
    
    @objc private func displayLinkAction() {
        timeOffset = .minimum(timeOffset+1/60, duration)
        // normalized time offset 0-1
        var time = timeOffset/duration
        time = bounceEaseOut(t: time)
        // interpolate position
        let position = interpolate(from: fromValue, to: toValue, time: time)
        
        ballView.center = position
        if timeOffset >= duration {
            link.invalidate()
            link = nil
        }
    }
    
    private func interpolate(from: CGPoint,
                             to: CGPoint,
                             time: TimeInterval) -> CGPoint {
        
        let result = CGPoint.init(x: interpolate(from: from.x, to: to.x, time: time), y: interpolate(from: from.y, to: to.y, time: time))
        return result
    }
    
    private func interpolate(from: CGFloat, to: CGFloat, time: TimeInterval) -> CGFloat {
        return (to - from) * CGFloat(time) + from
    }
    
    private func bounceEaseOut(t: TimeInterval) -> TimeInterval {
        if t < 4/11.0 {
            return (121 * t * t)/16.0
        } else if t < 8/11.0 {
            return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0
        } else if t < 9/10.0 {
            return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0
        }
        return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0
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
