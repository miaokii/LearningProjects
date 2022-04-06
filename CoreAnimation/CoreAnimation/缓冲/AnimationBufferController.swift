//
//  AnimationBufferController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/22.
//

import UIKit
import MiaoKiit

/*
 CAAnimation的timingFunction定义了缓冲方式：
 CAMediaTimingFunction类型初始化：
    linear  线性
    easeIn  慢加速进，突然停止
    easeOut 全速开始，慢速停止
    easeInEaseOut   慢速开始，慢速结束

 
 @available(iOS 3.0, *)
 public static let `default`: CAMediaTimingFunctionName
 */
class AnimationBufferController: MKViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        moveToTapTest()
        
        let custom = UIBarButtonItem.init(title: "Custom") {
            let vc = CustomTimingFuncController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        navigationItem.rightBarButtonItem = custom
    }

    private var dotLayer = CALayer.init()
    private func moveToTapTest() {
        dotLayer.frame = .init(origin: .zero, size: .init(width: 40, height: 40))
        dotLayer.cornerRadius = 20
        dotLayer.backgroundColor = UIColor.random.cgColor
        dotLayer.position = .init(x: view.width/2, y: (view.height-MKDefine.navAllHeight)/2)
        view.layer.addSublayer(dotLayer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: view) else { return }
//        uiViewBuffer(to: point)
        caTransactionBuffer(to: point)
    }
    
    private func uiViewBuffer(to point: CGPoint) {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .curveEaseInOut) {
            self.dotLayer.position = point
        } completion: { (_) in
            
        }
    }
    
    private func caTransactionBuffer(to point: CGPoint) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(1)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: .easeInEaseOut))
        dotLayer.position = point
        CATransaction.commit()
    }
}
