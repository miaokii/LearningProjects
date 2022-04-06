//
//  ReplicatorLayerController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/19.
//

import UIKit
import MiaoKiit

/*
 CAReplicatorLayer高效生成许多相似的图层
 会复制一个或多个图层的子图层，并在每个复制体上应用不同的变换
 */
class ReplicatorLayerController: MKViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        replicatorLayer()
        reflectionTest()
    }
    
    // 反射
    private func reflectionTest() {
        let reflectionView = ReflectionView.init(frame: .init(x: 20, y: 20, width: view.width-40, height: 200))
        view.addSubview(reflectionView)
    }
    
    private func replicatorLayer() {
        let containerView = UIView.init(super: view)
        containerView.frame = .init(x: 20, y: 200, width: view.width-40, height: 150)
        
        let replicatorLayer = CAReplicatorLayer.init()
        replicatorLayer.frame = containerView.bounds
        containerView.layer.addSublayer(replicatorLayer)
        
        replicatorLayer.instanceCount = 10
        
        // 每个复制体的变换
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 0, 200, 0)
        transform = CATransform3DRotate(transform, .pi/6, 0, 0, 1)
        transform = CATransform3DTranslate(transform, 0, -200, 0)
        replicatorLayer.instanceTransform = transform
        
        // 复制体颜色变化，逐步减少蓝色和绿色通道
        replicatorLayer.instanceBlueOffset = -0.1
        replicatorLayer.instanceGreenOffset = -0.1
        
        let layer = CALayer.init()
        layer.frame = .init(x: 100, y: 100, width: 100, height: 100)
        layer.backgroundColor = UIColor.white.cgColor
        replicatorLayer.addSublayer(layer)
        
        
    }
}

fileprivate class ReflectionView: UIView {
    override class var layerClass: AnyClass {
        return CAReplicatorLayer.classForCoder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        
        let image = UIImage.init(named: "chun")!
        let imageView = UIImageView.init(super: self, image: image)
        imageView.frame = bounds
        
        let replicator = layer as! CAReplicatorLayer
        replicator.repeatCount = 2
        
        // 反转变换
        var transform = CATransform3DIdentity
        let verticalOffset = bounds.size.height+2
        transform = CATransform3DTranslate(transform, 0, verticalOffset, 0)
        transform = CATransform3DScale(transform, 1, -1, 0)
        replicator.instanceTransform = transform
        
        replicator.instanceAlphaOffset = -0.6
    }
}
