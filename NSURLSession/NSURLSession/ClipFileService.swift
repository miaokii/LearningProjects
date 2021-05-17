//
//  ClipFileService.swift
//  NSURLSession
//
//  Created by miaokii on 2021/5/17.
//

import Foundation
import CommonCrypto

/// 文件切片信息
struct ClipFragmentInfo {
    var offset: UInt64
    var size: UInt64
    var clipName: String
}


/// 分片大小
fileprivate let fragmentSize: UInt64 = 1024*1024

/// 文件切片服务
struct ClipFileService {
    
    var fragments = [ClipFragmentInfo]()
    var fileSize: UInt64 = 0
    
    private var filePath: String
    private var readHandle: FileHandle?
    private var writeHandle: FileHandle?
    private var forRead = false
    private var fileManager = FileManager.default
    
    init(filePath: String, forRead: Bool = false) {
        self.filePath = filePath
        self.forRead = forRead
        getFileAttribute()
        if forRead {
            readHandle = FileHandle.init(forReadingAtPath: filePath)
            clipFile()
        } else {
            writeHandle = FileHandle.init(forWritingAtPath: filePath)
        }
    }
    
    /// 根据分片读取文件数据
    /// - Parameter fragment: 分片
    /// - Returns: 读取到数据
    func read(fragment: ClipFragmentInfo) -> Data? {
        guard let handle = readHandle else {
            return nil
        }
        handle.seek(toFileOffset: fragment.offset)
        return handle.readData(ofLength: Int(fragment.size))
    }
    
    /// 关闭文件
    func close() {
        if forRead {
            readHandle?.closeFile()
        } else {
            writeHandle?.closeFile()
        }
    }
    
    /// 获取文件属性，如果文件不存在就创建文件
    private mutating func getFileAttribute() {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: filePath) {
            fileManager.createFile(atPath: filePath, contents: nil, attributes: [:])
        }
        
        guard let attribute = try? fileManager.attributesOfItem(atPath: filePath) else {
            return
        }
        
        fileSize = attribute[.size] as! UInt64
    }
    
    /// 生成切片信息
    private mutating func clipFile() {
        // 分片数量
        let clipCount = (fileSize+fragmentSize-1)/fragmentSize
        var clipFragments = [ClipFragmentInfo]()
        
        for i in 0..<clipCount {
            let offSet = i * fragmentSize
            var clipSize = fragmentSize
            if i == clipCount-1 {
                clipSize = fileSize - i*fragmentSize
            }
            clipFragments.append(.init(offset: offSet,
                                       size: clipSize,
                                       clipName: Self.clipName))
        }
        self.fragments = clipFragments
    }
}

extension ClipFileService {
    static var clipName: String {
        func digest(input : NSData) -> NSData {
            let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
            var hash = [UInt8](repeating: 0, count: digestLength)
            CC_SHA256(input.bytes, UInt32(input.length), &hash)
            return NSData(bytes: hash, length: digestLength)
        }
        
        func hexStringFromData(input: NSData) -> String {
            var bytes = [UInt8](repeating: 0, count: input.length)
            input.getBytes(&bytes, length: input.length)
            
            var hexString = ""
            for byte in bytes {
                hexString += String(format:"%02x", UInt8(byte))
            }
            
            return hexString
        }
        
        let uuid = UUID.init().uuidString
        if let stringData = uuid.data(using: .utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
}
