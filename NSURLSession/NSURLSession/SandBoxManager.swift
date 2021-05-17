//
//  SandBoxManager.swift
//  NSURLSession
//
//  Created by miaokii on 2021/5/13.
//

import UIKit

class SandBoxManager {
    
    static let share = SandBoxManager.init()
    
    private let fileManager = FileManager.default
    
    /// 文件临时存储目录
    static var multipartFilePath = { () -> String in
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/MultipartFiles"
        guard !share.fileManager.fileExists(atPath: path) else {
            return path
        }
        do {
            try share.fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print(error)
        }
        return path
    }
    
    /// 删除
    static func delete(filePath: URL) {
        if share.fileManager.fileExists(atPath: filePath.path) {
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
    
    /// 将下载的文件保存在本地
    /// - Parameter path: 下载的文件路径
    static func copyDownloadItem(from: String, to: String) {
        do {
            try share.fileManager.copyItem(atPath: from, toPath: to)
        } catch(let error) {
            print(error)
        }
    }
    
    /// 将数据写入某个目录
    /// - Parameters:
    ///   - data: 数据
    ///   - path: 目录
    static func write(data: Data, to path: String) {
        (data as NSData).write(toFile: path, atomically: false)
    }
    
    /// 从某个目录读数据
    /// - Parameter path: 目录
    /// - Returns: 读取到的数据
    static func readData(from path: String) -> Data? {
        return try? Data.init(contentsOf: URL.init(fileURLWithPath: path))
    }
    

}
