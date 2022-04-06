//
//  TransformLayerController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/19.
//

import UIKit
import MiaoKiit

/*
 在3D情况下，所有的图层都将其孩子图层平面化到一个场景中
 所以不能单独的移动或者变换某一个图层
 
 CATransformLayer不同与普通的CALayer，不能显示自己的内容
 只有当存在了一个能作用于子图层的变换时才真正存在
 CATransformLayer并不平面化它的子图层，所以能够用于构造一个层级
 的3D结构

 */
class TransformLayerController: MKViewController {
    
    private var cubeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transformLayerTest()
    }
    
    private func transformLayerTest() {
        cubeView = UIView.init(super: view)
        cubeView.frame = .init(x: 30, y: 30, width: view.width-60, height: view.width-60)
        
        var pt = CATransform3DIdentity
        pt.m34 = -1/500
        cubeView.layer.sublayerTransform = pt
        
        // cube1
        var ct1 = CATransform3DIdentity
        ct1 = CATransform3DTranslate(ct1, -100, 0, 0)
        ct1 = CATransform3DRotate(ct1, .pi/3, 1, 0, 0)
        let cube1 = cube(with: ct1)
        cubeView.layer.addSublayer(cube1)
        
        // cube2
        var ct2 = CATransform3DIdentity
        ct2 = CATransform3DTranslate(ct2, 100, 0, 0)
        ct2 = CATransform3DRotate(ct2, .pi/4, 1, 0, 0)
        ct2 = CATransform3DRotate(ct2, -.pi/4, 0, 1, 0)
        let cube2 = cube(with: ct2)
        cubeView.layer.addSublayer(cube2)
    }
    
    // 面
    private func face(with transform: CATransform3D)->CALayer {
        // 面
        let face = CALayer.init()
        face.frame = .init(x: -50, y: -50, width: 100, height: 100)
        face.transform = transform
        face.backgroundColor = UIColor.random.cgColor
        return face
    }
    
    // 体
    private func cube(with transform: CATransform3D) -> CALayer {
        // cube layer
        let cube = CATransformLayer.init()
        
        // face 1
        var ct = CATransform3DMakeTranslation(0, 0, 50)
        cube.addSublayer(face(with: ct))
        
        // face 2
        ct = CATransform3DMakeTranslation(50, 0, 0)
        ct = CATransform3DRotate(ct, .pi/2, 0, 1, 0)
        cube.addSublayer(face(with: ct))
        
        // face 3
        ct = CATransform3DMakeTranslation(0, 50, 0)
        ct = CATransform3DRotate(ct, -.pi/2, 1, 0, 0)
        cube.addSublayer(face(with: ct))
        
        // face 4
        ct = CATransform3DMakeTranslation(0, -50, 0)
        ct = CATransform3DRotate(ct, .pi/2, 1, 0, 0)
        cube.addSublayer(face(with: ct))
        
        // face 5
        ct = CATransform3DMakeTranslation(-50, 0, 0)
        ct = CATransform3DRotate(ct, -.pi/2, 0, 1, 0)
        cube.addSublayer(face(with: ct))
        
        // face 6
        ct = CATransform3DMakeTranslation(0, 0, -50)
        ct = CATransform3DRotate(ct, .pi, 0, 1, 0)
        cube.addSublayer(face(with: ct))
        
        
        let cubeSize = cubeView.size
        cube.position = .init(x: cubeSize.width/2, y: cubeSize.height/2)
        
        cube.transform = transform
        return cube
    }
    
}
