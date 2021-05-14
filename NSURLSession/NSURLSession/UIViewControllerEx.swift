//
//  UIViewControllerEx.swift
//  NSURLSession
//
//  Created by miaokii on 2021/5/14.
//

import UIKit
import ZLPhotoBrowser
import Photos

enum AssetType {
    case image
    case video
}

class AssetViewController: UIViewController {
    
    var url: URL?
    private var asset: PHAsset?
    private var type: AssetType = .image
    private var image: UIImage?
    
    private var videoRequestComplete = false
    private var videoRequestID: PHImageRequestID?
    private var session: AVAssetExportSession!
    private var exportComplete:(()->Void)?
    
    func chooseImage(type: AssetType, complete: @escaping (()->Void)) {
        self.exportComplete = complete
        self.type = type
        
        let config = ZLPhotoConfiguration.default()
        config.maxSelectCount = 1
        config.style = .embedAlbumList
        config.languageType = .chineseSimplified
        config.allowEditImage = false
        config.allowEditVideo = false
        config.allowSelectOriginal = true
        
        config.allowSelectImage = type == .image
        config.allowSelectVideo = type == .video
        
        config.noAuthorityCallback = { (type) in
            switch type {
            case .library:
                HUD.flash(warning: "未获取相册权限")
            case .camera:
                HUD.flash(warning: "未获取相机权限")
            case .microphone:
                HUD.flash(warning: "未获取麦克风权限")
            }
        }
        
        let ac = ZLPhotoPreviewSheet.init()
        ac.selectImageBlock = { [weak self] (images, assets, irOriginal) in
            self?.asset = assets.first
            self?.url = nil
            self?.image = images.first
            self?.exportAssetLocal()
        }

        ac.showPhotoLibrary(sender: self)
    }
    
    /// 将选择的视频或图片倒出到沙盒
    private func exportAssetLocal() {
        exportImage()
        exportVideo()
    }
    
    private func exportImage() {
        guard type == .image, let image = image else {
            return
        }
        
        let fileName = String.decimal(value: Date().timeIntervalSince1970, style: .none)+".jpg"
        SandBoxManager.write(image: image, name: fileName) { [weak self] (url) in
            self?.url = url
            self?.exportComplete?()
        }
    }
    
    private func exportVideo() {
        guard type == .video, let videoAsset = asset else {
            self.exportComplete?()
            return
        }
        
        videoRequestComplete = false
        /// 请求视频数据的配置
        let videoOptions = PHVideoRequestOptions.init()
        videoOptions.deliveryMode = .highQualityFormat
        // 允许iCloud视频
        videoOptions.isNetworkAccessAllowed = true
        VideoDownloadHUD.show(string: "正在导出视频") {
            self.cancelVideoRequest()
        }
        videoRequestID = PHImageManager.default().requestAVAsset(forVideo: videoAsset, options: videoOptions) { [weak self] (avasset, audioMix, info) in
            VideoDownloadHUD.hide()
            guard let wself = self, let videoAsset = avasset as? AVURLAsset else {
                if let cancel = info?["PHImageCancelledKey"] as? Bool, cancel{
                    DispatchQueue.main.async {
                        HUD.flash(hint: "取消导出操作")
                    }
                } else if let err = info?["PHImageErrorKey"] as? Error {
                    DispatchQueue.main.async {
                        HUD.flash(hint: err.localizedDescription)
                    }
                }
                self?.url = nil
                self?.asset = nil
                return
            }
            wself.videoRequestComplete = true
            wself.startVideoExport(videoAsset: videoAsset)
        }
    }
    
    private func cancelVideoRequest() {
        guard let rid = videoRequestID else {
            return
        }
        
        if !videoRequestComplete {
            PHImageManager.default().cancelImageRequest(rid)
        }
        
        if let sess = session {
            sess.cancelExport()
        }
        videoRequestComplete = false
        videoRequestID = nil
    }
    
    private func startVideoExport(videoAsset: AVURLAsset) {
        session = AVAssetExportSession.init(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)
        guard let _ = session else {
            DispatchQueue.main.async {
                VideoDownloadHUD.hide()
                HUD.flash(hint: "导出视频发生错误，设备不受支持")
            }
            return
        }
        
        let videoName = String.decimal(value: Date().timeIntervalSince1970,style: .none) + ".mp4"
        let outputPath = SandBoxManager.multipartFilePath() + "/\(videoName)"
        session.shouldOptimizeForNetworkUse = true
        
        let supportTypes = session.supportedFileTypes
        guard supportTypes.count > 0, supportTypes.contains(.mp4) else {
            DispatchQueue.main.async {
                VideoDownloadHUD.hide()
                HUD.flash(hint: "该类型视频不支持导出")
            }
            return
        }
        session.outputFileType = .mp4
        session.outputURL = URL.init(fileURLWithPath: outputPath)
        session.exportAsynchronously { [weak self] in
            guard let wself = self, wself.videoRequestComplete else { return }
            VideoDownloadHUD.hide()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                var msg = ""
                switch wself.session.status {
                case .cancelled:
                    msg = "视频导出被取消"
                case .completed:
                    print("视频导出完成")
                    wself.url = wself.session.outputURL
                    wself.exportComplete?()
                case .failed:
                    msg = "视频导出失败"
                case .exporting:
                    msg = "正在导出视频"
                default:
                    msg = "发生错误，请重试"
                }
                if msg.count > 0 {
                    print(wself.session.error?.localizedDescription ?? "导出错误")
                    HUD.flash(hint: msg)
                } else {
                    HUD.hide()
                }
            })
        }
    }
}
