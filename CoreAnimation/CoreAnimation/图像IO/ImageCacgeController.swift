//
//  ImageCacgeController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/3/1.
//

import UIKit
import MiaoKiit

/*
 缓存到内存，注意查看内存使用情况
 */
class ImageCacgeController: MKViewController {
    
    private var imagePaths = [String]()
    private var collectionView: UICollectionView!
    private var cache = NSCache<AnyObject, AnyObject>.init()
    
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
    
    @discardableResult
    private func loadImageAt(index: Int, loadComplete: ((UIImage?)->Void)? = nil) -> UIImage? {
        let key = NSNumber(value: index)
        let image = cache.object(forKey: key) as? UIImage
        guard image == nil else {
            return image!
        }
        let path = imagePaths[index]
        DispatchQueue.global().async {
            var image = UIImage.init(contentsOfFile: path)
            UIGraphicsBeginImageContextWithOptions(image?.size ?? .zero, true, 0)
            image?.draw(at: .zero)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async {
                self.cache.setObject(image!, forKey: key)
                loadComplete?(image)
            }
        }
        return nil
    }
}

extension ImageCacgeController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagePaths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(type: ImageCell.self, at: indexPath)
        cell.imageView.image = loadImageAt(index: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        loadImageAt(index: indexPath.row) { (image) in
            (cell as! ImageCell).imageView.image = image
        }
    }
}

fileprivate class ImageCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    // 使用tileLayer加载
    private var tileLayer: CATiledLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView.init(super: contentView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
