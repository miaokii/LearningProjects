//
//  TextDetectorController.swift
//  CIDetector
//
//  Created by yoctech on 2021/11/11.
//

import UIKit

class TextDetectorController: DetectorViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 高精度
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        detector = CIDetector.init(ofType: CIDetectorTypeText, context: nil, options: options)
    }
    
    override func selectImageComplete() {
        super .selectImageComplete()
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
            let textFeature = feature as! CITextFeature
            
        }
        
        logTextFeatures(features: features as! [CITextFeature], level: 0)
        self.textView.text = "检测到\(features.count)个人脸"
    }
    
    func logTextFeatures(features: [CITextFeature], level : Int) {
        let mString = NSMutableString.init()
        for i in 0..<level {
            if (i < level-1) {
                mString.append("    ")
            }
            else {
                mString.append("  |-")
            }
        }
        for feature in features {
            print("\(mString), rect: \(feature.bounds)")
            logTextFeatures(features: feature.subFeatures as! [CITextFeature], level: level+1)
        }
    }
}
