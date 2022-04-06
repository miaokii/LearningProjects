//
//  EmitterLayerController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/19.
//

import UIKit
import MKSwiftRes

/*
 粒子效果
 */

class EmitterLayerController: MKViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        emitterTest()
        fireworks()
    }
    
    // 烟花效果
    private func fireworks() {
        view.backgroundColor = .black
        
        let fireworkLayer = CAEmitterLayer.init()
        fireworkLayer.frame = view.bounds
        view.layer.addSublayer(fireworkLayer)
        // 发射源位置
        fireworkLayer.emitterPosition = .init(x: view.width/2, y: view.height-MKDefine.navAllHeight)
        // 发射源尺寸
        fireworkLayer.emitterSize = .init(width: 50, height: 0)
        // 发射源模式
        /*
         outline：从发射器边发射
         points：从发射器上的顶点发射
         */
        fireworkLayer.emitterMode = .outline
        // 发射源形状
        fireworkLayer.emitterShape = .line
        // 渲染模式
        fireworkLayer.renderMode = .additive
        // z轴效果
        fireworkLayer.preservesDepth = true
        // 发射速度
        fireworkLayer.velocity = 1
        // 产生随机粒子
        fireworkLayer.seed = arc4random()%100+1
        
        // 发射出去爆炸前的烟花
        let cell = CAEmitterCell.init()
        // 每秒产生粒子数
        cell.birthRate = 0.5
        // 发射角度偏移量
        cell.emissionRange = .pi*0.11
        // 发射速度
        cell.velocity = 300
        // 速度偏移量
        cell.velocityRange = 150
        // y轴速度增量
        cell.yAcceleration = 75
        // 粒子存在时间
        cell.lifetime = 3
        // 粒子图像
        cell.contents = UIImage.init(named: "dot-2")?.cgImage
        // 粒子缩放值
        cell.scale = 0.5
        // 三原色透明度偏移量
        cell.greenRange = 1
        cell.redRange = 1
        cell.blueRange = 1
        // 粒子旋转偏移量
        cell.spinRange = .pi
        
        // 爆炸
        let burst = CAEmitterCell.init()
        burst.birthRate = 1
        burst.velocity = 0
        burst.scale = 2.5
        // 三原色变色速率
        burst.redSpeed = -1.5
        burst.blueSpeed = 1.5
        burst.greenSpeed = 1
        burst.lifetime = 0.2
        
        // 火花
        let spark = CAEmitterCell.init()
        spark.birthRate = 1000
        spark.velocity = 125
        spark.emissionRange = .pi*2
        spark.yAcceleration = 75
        spark.lifetime = 2
        spark.contents = UIImage.init(named: "star")?.cgImage
        spark.scaleSpeed = -0.2
        spark.greenSpeed = -0.1
        spark.redSpeed = 0.4
        spark.blueSpeed = -0.1
        spark.alphaSpeed = -0.25
        spark.spin = .pi*2
        spark.spinRange = .pi*2
        
        fireworkLayer.emitterCells = [cell]
        cell.emitterCells = [burst]
        burst.emitterCells = [spark]
    }
    
    private func emitterTest() {
        let emitter = CAEmitterLayer.init()
        emitter.frame = view.bounds
        view.layer.addSublayer(emitter)
        emitter.renderMode = .additive
        // 粒子发射出的位置
        emitter.emitterPosition = .init(x: view.width/2, y: view.height/2-MKDefine.navAllHeight)
        
        let cell = CAEmitterCell.init()
        cell.contents = UIImage.init(named: "xuehua")?.cgImage
        // 每一秒创建的粒子数
        cell.birthRate = 150
        // 粒子持续时间
        cell.lifetime = 5
        // 可以混合图片内容颜色的混合色
        cell.color = UIColor.orange.cgColor
        // 透明度每过1s减少0.4
        cell.alphaSpeed = -0.4
        // 尺寸每秒减少0.2
        cell.scaleSpeed = -0.2
        // 粒子初始速度
        cell.velocity = 50
        // 粒子初始速度范围
        cell.velocityRange = 50
        // 可以从任意角度射出粒子
        cell.emissionRange = .pi
        
        /*
         CAEMitterCell的属性基本上可以分为三种
            - 属性初始值，color、velocity、birthRate ...
            - 属性范围变化，velocityRange、alphaRange、emissionRange ...
            - 指定值在时间线上的变化，scaleSpeed、alphaSpeed、blueSpeed
         */
        
        emitter.emitterCells = [cell]
    }
    
}
