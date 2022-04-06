//
//  ShadowViewController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/18.
//

import UIKit
import MiaoKiit

class ShadowViewController: MKViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        shadowTest()
        maskTest()
    }
    
    private func shadowTest() {
        let whiteView = UIView.init(super: view,
                                    backgroundColor: .clear)
        whiteView.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(200)
        }
        
        // whiteView.layer.borderWidth = 1
        /// 曲率
        whiteView.layer.cornerRadius = 5
        /// 阴影透明度
        whiteView.layer.shadowOpacity = 0.5
        /// 阴影的方向和距离
        /// 默认（0，-3）
        whiteView.layer.shadowOffset = .init(width: 0, height: 5)
        /// 阴影的模糊度，为0的时，阴影和视图有非常明确的边界线
        /// 值越大，边界越模糊和自然
        whiteView.layer.shadowRadius = 5
        /// 涂层的阴影继承自内容的外形，而不是根据边界和角半径
        whiteView.layer.contentsGravity = .resizeAspect
        whiteView.layer.contents = UIImage.init(named: "juzi")?.cgImage
        
        /// 既然阴影是根据内容的形状绘制
        /// 内容是否透明和子图层都会影响阴影
        /// 阴影可以绘制为任意的矢量图形
        /// 即阴影可以是任意形状
        
        /// 矩形
        let squarePath = CGMutablePath.init()
        squarePath.addRect(whiteView.bounds)
//        whiteView.layer.shadowPath = squarePath
        
        /// 圆形
        let circlePath = CGMutablePath.init()
        circlePath.addEllipse(in: whiteView.bounds)
//        whiteView.layer.shadowPath = circlePath
        
    }

    private func maskTest() {
        let whiteView = UIView.init(super: view,
                                    backgroundColor: .clear)
        whiteView.size = .init(width: 200, height: 200)
        whiteView.center = view.center
        
        /// 曲率
        whiteView.layer.cornerRadius = 5
        /// 阴影透明度
        whiteView.layer.shadowOpacity = 0.5
        /// 阴影的方向和距离
        /// 默认（0，-3）
        whiteView.layer.shadowOffset = .init(width: 0, height: 5)
        /// 阴影的模糊度，为0的时，阴影和视图有非常明确的边界线
        /// 值越大，边界越模糊和自然
        whiteView.layer.shadowRadius = 5
        /// 涂层的阴影继承自内容的外形，而不是根据边界和角半径
        whiteView.layer.contentsGravity = .resizeAspectFill
        whiteView.layer.contents = UIImage.init(named: "juzi")?.cgImage
        
        /// mask蒙板，门板是一个layer对象
        /// 蒙板定义了图层的可见区域，蒙板外的部分会被不显示
        /// 可以利用有透明通道的图片创建蒙版图层
        /// 给mask设置color无效
        let maskLayer = CALayer.init()
        maskLayer.frame = whiteView.bounds
        let maskImage = UIImage.init(named: "chun")!
        maskLayer.contents = maskImage.cgImage
        whiteView.layer.mask = maskLayer
    }
}
