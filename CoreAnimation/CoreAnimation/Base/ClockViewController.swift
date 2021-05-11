//
//  ClockViewController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/18.
//

import UIKit
import MKSwiftRes

class ClockViewController: MKViewController{
    
    private var timer: MKWTimer!
    private var hourPin: UIView!
    private var minPin: UIView!
    private var secondPin: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clockTest()
    }
    
    private func clockTest() {
        let clockView = UIView.init(super: view,
                                    backgroundColor: .table_bg,
                                    cornerRadius: 100)
        clockView.layer.borderWidth = 1
        clockView.layer.borderColor = UIColor.black.cgColor
        clockView.size = .init(width: 200, height: 200)
        clockView.center = .init(x: view.width/2,
                                 y: view.height/2-MKDefine.navAllHeight)
        
        hourPin = UIView.init(super: view,
                                  backgroundColor: .black)
        hourPin.size = .init(width: 2, height: 40)
        hourPin.center = clockView.center
            
        minPin = UIView.init(super: view,
                                  backgroundColor: .gray)
        minPin.size = .init(width: 2, height: 60)
        minPin.center = clockView.center
        
        secondPin = UIView.init(super: view,
                                    backgroundColor: .red)
        secondPin.size = .init(width: 2, height: 95)
        secondPin.center = clockView.center
        
        let dotView = UIView.init(super: view,
                                  backgroundColor: secondPin.backgroundColor,
                                  cornerRadius: 2)
        dotView.size = .init(width: 4, height: 4)
        dotView.center = clockView.center
        
        hourPin.layer.anchorPoint = .init(x: 0.5, y: 0.9)
        minPin.layer.anchorPoint = .init(x: 0.5, y: 0.9)
        secondPin.layer.anchorPoint = .init(x: 0.5, y: 0.9)
        
        timer = MKWTimer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick))
        tick()
    }
    
    @objc private func tick() {
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
        
        hourPin.transform = CGAffineTransform.init(rotationAngle: hoursAngle)
        minPin.transform = CGAffineTransform.init(rotationAngle: minAngle)
        secondPin.transform = CGAffineTransform.init(rotationAngle: secondAngle)
    }
    
    deinit {
        timer.invalidate()
    }
}
