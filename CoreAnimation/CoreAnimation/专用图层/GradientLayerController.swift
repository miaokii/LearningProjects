//
//  GradientLayerController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/19.
//

import UIKit
import MiaoKiit

/*
    渐变图层，会使用硬件加速绘制
 */
class GradientLayerController: MKViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        red_blue_gradient()
        multipleGradient()
    }
    
    // 基础渐变
    private func red_blue_gradient() {
        let gradientView = UIView.init(super: view)
        gradientView.frame = .init(x: 20, y: 20, width: view.width-40, height: 150)
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
        
        gradientLayer.colors = [UIColor.red.cgColor,
                                UIColor.blue.cgColor]
        
        // 开始点单为坐标
        gradientLayer.startPoint = .init(x: 0, y: 0)
        // 结束点单位坐标
        gradientLayer.endPoint = .init(x: 1, y: 1)
    }
    
    // 多重渐变
    private func multipleGradient() {
        let gradientView = UIView.init(super: view)
        gradientView.frame = .init(x: 20, y: 200, width: view.width-40, height: 150)
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
        
        // 多个颜色渐变
        gradientLayer.colors = [UIColor.purple.cgColor,
                                UIColor.green.cgColor,
                                UIColor.cyan.cgColor,
                                UIColor.red.cgColor]
        // 渐变位置
        gradientLayer.locations = [0.1, 0.3, 0.5, 0.9]
        
        // 开始点单为坐标
        gradientLayer.startPoint = .init(x: 0.5, y: 0)
        // 结束点单位坐标
        gradientLayer.endPoint = .init(x: 0.5, y: 1)
    }

}
