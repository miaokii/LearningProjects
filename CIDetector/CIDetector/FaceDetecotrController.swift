//
//  FaceDetecotrController.swift
//  CIDetector
//
//  Created by yoctech on 2021/10/28.
//

import UIKit

class FaceDetecotrController: DetectorViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "检测人脸"
        
        // 高精度
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        detector = CIDetector.init(ofType: CIDetectorTypeFace, context: nil, options: options)
    }
    
    override func selectImageComplete() {
        guard let image = self.image else {
            return
        }
        
        self.imageView.subviews.forEach { subView in
            subView.removeFromSuperview()
        }
        
        self.resize(image: image)
        
        let ciImage = CIImage.init(cgImage: image.cgImage!)
        // CIFaceFeature类型的特征集合
        let features = detector.features(in: ciImage)
        
        for feature in features {
            let face = feature as! CIFaceFeature
            let faceView = UIView.init(frame: self.resize(rect: face.bounds));
            faceView.layer.borderWidth = 1;
            faceView.layer.borderColor = UIColor.red.cgColor;
            imageView .addSubview(faceView)
        }
        
        self.textView.text = "检测到\(features.count)个人脸"
    }
}


