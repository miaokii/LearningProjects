//
//  ImageLoadController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/26.
//

import UIKit
import MKSwiftRes

class ImageLoadController: MKViewController {
    
    private var imagePaths = [String]()
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bundlePath = Bundle.main.resourcePath,
           let imageBundle = Bundle.init(path: "\(bundlePath)/Image.bundle") {
            imagePaths = imageBundle.paths(forResourcesOfType: "jpeg", inDirectory: nil)
        }
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = .init(width: view.width, height: view.width*9/16)
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .view_l1
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        collectionView.register(cellType: ImageCell.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

extension ImageLoadController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagePaths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(type: ImageCell.self, at: indexPath)
        cell.set(image: imagePaths[indexPath.row])
        return cell
    }
}

fileprivate class ImageCell: UICollectionViewCell {
    
    private var imageView: UIImageView!
    
    // 使用tileLayer加载
    private var tileLayer: CATiledLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView.init(super: contentView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    func set(image path: String) {
        
        // 这种方法加载图片会避免延时加载，即加载后立刻解压
        // UIImage.init(named: "image")
        
         uikitImage(path: path)
//        tileImage(path: path)
    }
    
    // 直接加载最耗时，图片大时会阻塞主线程
    private func image(path: String) {
        imageView.image = UIImage.init(contentsOfFile: path)
    }
    
    // GCD加载
    private func globalImage(path: String) {
        DispatchQueue.global().async {
            let image = UIImage.init(contentsOfFile: path)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    // 使用ImageIO框架，kCGImageSourceShouldCache创建图片，强制立刻解压
    private func imageIO(path: String) {
        let options = [kCGImageSourceShouldCache:true]
        let url = URL.init(fileURLWithPath: path)
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
              let imageRef = CGImageSourceCreateImageAtIndex(source, 0, options as CFDictionary) else {
            return
        }
        
        let image = UIImage.init(cgImage: imageRef)
        imageView.image = image
    }
    
    /// 重绘图像大小，匹配imageView
    private func uikitImage(path: String) {
        let size = imageView.bounds.size
        DispatchQueue.global().async {
            var image = UIImage.init(contentsOfFile: path)
            UIGraphicsBeginImageContextWithOptions(size, true, 0)
            image?.draw(in: .init(origin: .zero, size: size))
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    private func tileImage(path: String) {
        if tileLayer == nil {
            imageView.removeFromSuperview()
            tileLayer = CATiledLayer.init()
            tileLayer!.frame = bounds
            let scale = UIScreen.main.scale
            tileLayer!.contentsScale = scale
            tileLayer!.tileSize = .init(width: bounds.width*scale, height: bounds.height*scale)
            tileLayer!.delegate = self
            contentView.layer.addSublayer(tileLayer!)
        }
        
        tileLayer!.contents = nil
        tileLayer!.setValue(path, forKey: "imagePath")
        tileLayer!.setNeedsDisplay()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension ImageCell {
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        let imagePath = layer.value(forKey: "imagePath") as! String
        guard let image = UIImage.init(contentsOfFile: imagePath) else {
            return
        }
        let ratio = image.size.height/image.size.width
        var imageRect: CGRect = .zero
        imageRect.size = .init(width: layer.bounds.size.width, height: layer.bounds.size.height * ratio)
        imageRect.origin.y = (layer.bounds.size.height-imageRect.size.height)/2
        
        UIGraphicsPushContext(ctx)
        image.draw(in: imageRect)
        UIGraphicsPopContext()
    }
}
