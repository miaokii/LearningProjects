//
//  DetectorViewController.swift
//  CIDetector
//
//  Created by yoctech on 2021/10/28.
//

import UIKit

class DetectorViewController: UIViewController {
    
    var imageView = UIImageView()
    var textView = UITextView()
    var image: UIImage?
    
    var detector: CIDetector!
    
    private var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let chooseImage = UIBarButtonItem.init(image: UIImage.init(systemName: "photo.on.rectangle.angled")) { [weak self] in
            self?.present(self!.imagePicker, animated: true, completion: nil)
        }
        self.navigationItem.rightBarButtonItem = chooseImage;
        
        view.addSubview(imageView)
        imageView.backgroundColor = .init(0xF4F7F9)
        imageView.contentMode = .scaleToFill
        imageView.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view).multipliedBy(0.8)
            make.height.equalTo(self.view.frame.width*0.8*9.0/16)
        }
        
        textView.isEditable = false
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.width.centerX.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.bottom.equalTo(-40)
        }
        
        textView.text = "未识别"
        
        imagePicker = UIImagePickerController.init()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }
    
    func selectImageComplete() {
        
    }
    
    func resize(image: UIImage) {
        let size = image.size;
        let w = self.view.frame.width * 0.8
        let h = w * size.height / size.width
        
        imageView.snp.remakeConstraints { make in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(w)
            make.height.equalTo(h)
        }
        
        imageView.image = image
    }

    func resize(rect: CGRect) -> CGRect {
        guard let imgSize = self.imageView.image?.size else {
            return .zero
        }
        
        let wRate = imageView.size.width/imgSize.width
        let hRate = imageView.size.height/imgSize.height
        // 是别的坐标系的原点是图像的左下角，UIKit的原调是屏幕左上角，需要转换
        return .init(x: rect.minX * wRate, y: (imgSize.height - rect.maxY) * hRate, width: rect.width * wRate, height: rect.height * hRate);
    }
}

extension DetectorViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        self.image = image
        self.selectImageComplete()
    }
}
