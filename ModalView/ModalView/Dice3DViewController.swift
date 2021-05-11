//
//  Dice3DViewController.swift
//  ModalView
//
//  Created by miaokii on 2021/2/1.
//

import UIKit
import MKSwiftRes

class Dice3DViewController: MKViewController {

    private var diceView: UIView!
    private var angle = CGPoint.zero
    private var timer: MKWTimer!
    private var transform = CATransform3DIdentity
    
    private var tabBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "骰子"
        let diceWidth: CGFloat = 100
        // 处理手势，如果直接添加到旋转视图上，视图旋转时，坐标系也旋转，不能正确获得旋转角度
        // 所以以一个不动的视图作为基准
        diceView = UIView.init(super: view,
                               backgroundColor: .clear)
        diceView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(40)
            make.size.equalTo(diceWidth)
        }
        
        // CATransform3D 是采用三维坐标系统，x 轴向下为正，y 向右为正，z 轴则是垂直于屏幕向外为正
        var diceTransform = CATransform3DIdentity
        
        // 1点，垂直于z轴，不做旋转
        let dice1View = UIImageView.init(super: diceView,
                                           // image: UIImage.init(named: "dice1"))
                                         backgroundColor: UIColor.random.withAlphaComponent(0.5))
        // CATransform3DTranslate会旋转整个坐标系
        diceTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, diceWidth/2)
        dice1View.layer.transform = diceTransform
        dice1View.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        // 2点
        let dice2View = UIImageView.init(super: diceView,
                                         // image: UIImage.init(named: "dice2"))
                                         backgroundColor: UIColor.random.withAlphaComponent(0.5))
        // 垂直于y轴，绕x轴旋转90度
        diceTransform = CATransform3DRotate(CATransform3DIdentity, .pi/2, 0, 1, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, diceWidth/2)
        dice2View.layer.transform = diceTransform
        dice2View.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        // 3点
        let dice3View = UIImageView.init(super: diceView,
//                                         image: UIImage.init(named: "dice3"))
                                         backgroundColor: UIColor.random.withAlphaComponent(0.5))
        // 垂直于x轴，绕x轴旋转90度
        diceTransform = CATransform3DRotate(CATransform3DIdentity, -.pi/2, 1, 0, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, diceWidth/2)
        dice3View.layer.transform = diceTransform
        dice3View.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        // 4点
        let dice4View = UIImageView.init(super: diceView,
//                                         image: UIImage.init(named: "dice4"))
                                         backgroundColor: UIColor.random.withAlphaComponent(0.5))
        // 垂直于x轴，绕x轴旋转90度
        diceTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, -diceWidth/2)
        dice4View.layer.transform = diceTransform
        dice4View.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        // 5点
        let dice5View = UIImageView.init(super: diceView,
//                                         image: UIImage.init(named: "dice5"))
                                         backgroundColor: UIColor.random.withAlphaComponent(0.5))
        // 垂直于x轴，绕x轴旋转90度
        diceTransform = CATransform3DRotate(CATransform3DIdentity, -.pi/2, 1, 0, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, -diceWidth/2)
        dice5View.layer.transform = diceTransform
        dice5View.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        // 6点
        let dice6View = UIImageView.init(super: diceView,
//                                         image: UIImage.init(named: "dice6"))
                                         backgroundColor: UIColor.random.withAlphaComponent(0.5))
        // 垂直于x轴，绕x轴旋转90度
        diceTransform = CATransform3DRotate(CATransform3DIdentity, .pi/2, 0, 1, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, -diceWidth/2)
        dice6View.layer.transform = diceTransform
        dice6View.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture(sender:)))
        diceView.addGestureRecognizer(pan)
        
        transform.m34 = -1/500
        timer = MKWTimer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(timeRoate))
        
        tabBarView = UIView.init(super: view,
                                     backgroundColor: .clear)
        tabBarView.snp.makeConstraints { (make) in
            make.top.equalTo(diceView.snp.bottom).offset(80)
            make.size.equalTo(diceView)
            make.centerX.equalToSuperview()
        }
        
        let btn1 = UIButton.themeBtn(super: view, title: "1", target_selector: (self, #selector(tabItemSwitch(sender:))))
        btn1.tag = 0
        btn1.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().multipliedBy(0.5)
            make.top.equalTo(tabBarView.snp.bottom).offset(40)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        let btn2 = UIButton.themeBtn(super: view, title: "2", target_selector: (self, #selector(tabItemSwitch(sender:))))
        btn2.tag = 1
        btn2.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(tabBarView.snp.bottom).offset(40)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        let btn3 = UIButton.themeBtn(super: view, title: "3", target_selector: (self, #selector(tabItemSwitch(sender:))))
        btn3.tag = 2
        btn3.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().multipliedBy(1.5)
            make.top.equalTo(tabBarView.snp.bottom).offset(40)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        var tabTransform = CATransform3DIdentity
        let tabItem1 = UIView.init(super: tabBarView,
                                   backgroundColor: UIColor.random.withAlphaComponent(0.6))
        tabItem1.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, diceWidth/2)
        tabItem1.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        let tabItem2 = UIView.init(super: tabBarView,
                                   backgroundColor: UIColor.random.withAlphaComponent(0.6))
        tabTransform = CATransform3DRotate(CATransform3DIdentity, .pi/2, 0, 1, 0)
        tabTransform = CATransform3DTranslate(tabTransform, 0, 0, diceWidth/2)
        tabItem2.layer.transform = tabTransform
        tabItem2.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        let tabPan = UIPanGestureRecognizer.init(target: self, action: #selector(tabPanGesture(sender:)))
        tabBarView.addGestureRecognizer(tabPan)
    }
    
    private var oldTag = 0
    @objc private func tabItemSwitch(sender: UIButton) {
        
        // 向右
//        let direction: CGFloat = oldTag < sender.tag ? 1 : -1
        
//        var toTransform = CATransform3DIdentity
//        toTransform = CATransform3DRotate(CATransform3DIdentity, .pi/2, 1, 0, 0)
//        toTransform = CATransform3DTranslate(toTransform, 0, 0, -direction*animateContainer.frame.width/2)
//        toView.layer.transform = toTransform
    
        UIView.animate(withDuration: 2) {
            var transform = self.tabBarView.layer.sublayerTransform
            transform.m34 = 1/500
            self.tabBarView.layer.sublayerTransform = CATransform3DRotate(transform,
                                                                   .pi/2, 0, 1, 0)
        } completion: { (_) in
//            self.tabBarView.layer.sublayerTransform = CATransform3DIdentity
        }
    }
    
    private var panAngle = CGPoint.zero
    @objc private func tabPanGesture(sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: tabBarView)
        
        let angleX = panAngle.x + point.x/30
        let angleY = panAngle.y - point.y/30
        
        transform = CATransform3DIdentity
        transform.m34 = -1/500
        transform = CATransform3DRotate(transform, angleX, 0, 1, 0)
        transform = CATransform3DRotate(transform, angleY, 1, 0, 0)
        // blueView是手势旋转的基准，所以不能直接对其做旋转，而是旋转其subLayer：sublayerTransform
        // 旋转子layer
        tabBarView.layer.sublayerTransform = transform
        
        if sender.state == .ended {
            panAngle = .init(x: angleX, y: angleY)
        }
    }
    
    @objc private func panGesture(sender: UIPanGestureRecognizer) {
        
        if sender.state == .began {
            timer.fireDate = .distantFuture
        }
        
        let point = sender.translation(in: diceView)
        let angleX = angle.x + point.x/30
        let angleY = angle.y - point.y/30
        
        transform = CATransform3DIdentity
        transform.m34 = -1/500
        transform = CATransform3DRotate(transform, angleX, 0, 1, 0)
        transform = CATransform3DRotate(transform, angleY, 1, 0, 0)
        // blueView是手势旋转的基准，所以不能直接对其做旋转，而是旋转其subLayer：sublayerTransform
        // 旋转子layer
        diceView.layer.sublayerTransform = transform
        
        if sender.state == .ended {
            timer.fireDate = .distantPast
            angle = .init(x: angleX, y: angleY)
        }
    }
    
    @objc private func timeRoate() {
        transform = CATransform3DRotate(transform, .pi/360, 1, 1, 0.5)
        diceView.layer.sublayerTransform = transform
    }
    
    deinit {
        timer.invalidate()
    }
}
