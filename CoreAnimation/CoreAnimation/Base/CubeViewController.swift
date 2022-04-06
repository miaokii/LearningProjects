//
//  ViewController.swift
//  CoreAnimation
//
//  Created by Miaokii on 2021/2/5.
//

import UIKit
import MiaoKiit
import GLKit

// MARK: - 固体对象，创建光照阴影效果的立方体
fileprivate let LIGHT_DIRECTION:(Float, Float, Float) = (0, 1, -0.5)
fileprivate let AMBIENT_LEGHT: Float = 0.5
class CubeViewController: MKViewController {
    
    private var cubeContainerView:  UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        solidObjectTest()
    }
    
    private func solidObjectTest() {
        view.backgroundColor = .lightGray
        cubeContainerView = UIView.init(super: view,
                                        backgroundColor: .clear)
        cubeContainerView.size = .init(width: 200, height: 200)
        cubeContainerView.center = .init(x: MKDefine.screenWidth/2, y: MKDefine.screenHeight/2-MKDefine.navAllHeight)
        
        // cube face 1
        var transform = CATransform3DMakeTranslation(0, 0, 100)
        addFace(index: 0, with: transform)
        
        // cube face 2
        transform = CATransform3DMakeTranslation(100, 0, 0)
        transform = CATransform3DRotate(transform, .pi/2, 0, 1, 0)
        addFace(index: 1, with: transform)
        
        // cube face 3
        transform = CATransform3DMakeTranslation(0, -100, 0)
        transform = CATransform3DRotate(transform, .pi/2, 1, 0, 0)
        addFace(index: 2, with: transform)
        
        // cube face 4
        transform = CATransform3DMakeTranslation(0, 100, 0)
        transform = CATransform3DRotate(transform, -.pi/2, 1, 0, 0)
        addFace(index: 3, with: transform)
        
        // cube face 5
        transform = CATransform3DMakeTranslation(-100, 0, 0)
        transform = CATransform3DRotate(transform, -.pi/2, 0, 1, 0)
        addFace(index: 4, with: transform)
        
        // cube face 6
        transform = CATransform3DMakeTranslation(0, 0, -100)
        transform = CATransform3DRotate(transform, .pi, 0, 1, 0)
        addFace(index: 5, with: transform)
        
        var perspective = CATransform3DIdentity
        perspective.m34 = -1 / 500
        perspective = CATransform3DRotate(perspective, -.pi/4, 1, 0, 0)
        perspective = CATransform3DRotate(perspective, -.pi/4, 0, 1, 0)
        cubeContainerView.layer.sublayerTransform = perspective
        
        // 不渲染视图背面的内容
        cubeContainerView.layer.isDoubleSided = false
    }
    
    /// 添加面
    private func addFace(index: Int, with transform: CATransform3D) {
        let face = UIView.init(super: cubeContainerView)
        let size = cubeContainerView.bounds.size
        face.size = size
        
        let num = UILabel.init(super: face)
        num.backgroundColor = .clear
        num.text = "\(index+1)"
        num.textColor = .random
        num.font = .systemFont(ofSize: 35)
        num.textAlignment = .center
        
        face.center = .init(x: size.width/2, y: size.height/2)
        face.layer.transform = transform
        num.frame = face.bounds
        
        if index == 2 {
            let button = UIButton.init(super: face,
                                       backgroundImage: UIImage.init(color: .blue))
            face.bringSubviewToFront(num)
            button.size = .init(width: 70, height: 70)
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
            button.origin = .init(x: (size.width-button.size.width)/2, y: (size.height-button.size.height)/2)
            button.addTarget(self, action: #selector(tapedFace3), for: .touchUpInside)
        } else {
            face.isUserInteractionEnabled = false
        }
        
        applyLightTo(face: face.layer)
    }
    /// 点击事件的处理是由视图在父视图中的顺序决定的
    /// 并不是3D空间中的z轴顺序
    /// 如果按照1-6的顺序添加6个面，4、5、6都在3的前面
    /// 所以不会响应3的按钮点击方法，因为点击事件被4、5、6拦截了
    /// 解决方式是：
    ///     1、将3面添加到6面的后面
    ///     2、将其他面的userInteractionEnabled设置成false
    @objc private func tapedFace3() {
        print("taped face 3")
    }
    
    /// 添加光影
    private func applyLightTo(face: CALayer) {
        let layer = CALayer.init()
        layer.frame = face.bounds
        face.addSublayer(layer)
        
        let transform = face.transform
        // GLKMatrix4和CATransform3D内存结构一致，坐标类型长度有区别，做一次转换
        let matrix4 = GLKMatrix4.init(m: transform.m)
        let matrix3 = GLKMatrix4GetMatrix3(matrix4)
        
        // face normal
        var normal = GLKVector3Make(0, 0, 1)
        normal = GLKMatrix3MultiplyVector3(matrix3, normal)
        normal = GLKVector3Normalize(normal)
        
        // get dot product with light direction
        let light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION.0, LIGHT_DIRECTION.1, LIGHT_DIRECTION.2))
        let dotProduct = GLKVector3DotProduct(light, normal)
        
        // set lighting layer opacity
        let shadow = 1 + dotProduct - AMBIENT_LEGHT
        let color = UIColor.init(white: 0, alpha: CGFloat(shadow))
        layer.backgroundColor = color.cgColor
    }
}

extension CATransform3D {
    var m: (Float, Float, Float, Float,
            Float, Float, Float, Float,
            Float, Float, Float, Float,
            Float, Float, Float, Float) {
        return (Float(self.m11), Float(self.m12), Float(self.m13), Float(self.m14),
                Float(self.m21), Float(self.m22), Float(self.m23), Float(self.m24),
                Float(self.m31), Float(self.m32), Float(self.m33), Float(self.m34),
                Float(self.m41), Float(self.m42), Float(self.m43), Float(self.m44))
    }
}
