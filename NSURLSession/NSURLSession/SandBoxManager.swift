//
//  SandBoxManager.swift
//  NSURLSession
//
//  Created by miaokii on 2021/5/13.
//

import UIKit

class SandBoxManager {
    /// 文件临时存储目录
    static var multipartFilePath = { () -> String in
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/MultipartFiles"
        guard !FileManager.default.fileExists(atPath: path) else {
            return path
        }
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print(error)
        }
        return path
    }
    
    /// 删除
    static func delete(filePath: URL) {
        if FileManager.default.fileExists(atPath: filePath.path) {
            try? FileManager.default.removeItem(atPath: filePath.path)
        }
    }
    
    /// 写图片
    static func write(image: UIImage, name:String, complete: @escaping (URL?)->()) {
        if let imageData = image.jpegData(compressionQuality: 1) {
            let imageUrl = multipartFilePath() + "/\(name)"
            let nsData = NSData.init(data: imageData)
            
            if nsData.write(toFile: imageUrl, atomically: false) {
                complete(URL.init(fileURLWithPath: imageUrl))
            } else {
                complete(nil)
            }
        } else {
            complete(nil)
        }
    }
}
