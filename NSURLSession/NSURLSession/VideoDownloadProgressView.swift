//
//  VideoExportViews.swift
//  JXCivilServe
//
//  Created by miaokii on 2021/4/7.
//

import UIKit

class VideoDownloadProgressView: UIView {
    
    private var cancelBtn = UIButton.init()
    private var indicatorView = UIActivityIndicatorView.init()
    
    var titleLabel = UILabel()
    var cancelClosure:(()->Void)?
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 100, height: 100)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cancelBtn.setImage(UIImage.init(named: "hide")?.tintTo(tintColor: HUD.lightContentColor), for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.right.top.equalTo(0)
            make.size.equalTo(20)
        }

        if #available(iOS 13.0, *) {
            indicatorView.style = .large
        } else {
            indicatorView.style = .whiteLarge
        }
        addSubview(indicatorView)
        indicatorView.startAnimating()
        indicatorView.color = HUD.lightContentColor
        indicatorView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(cancelBtn.snp.bottom).offset(5)
        }

        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.textColor = HUD.lightContentColor
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(indicatorView.snp.bottom).offset(5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func cancel() {
        DispatchQueue.main.async {
            self.cancelClosure?()
        }
    }
}

class VideoDownloadHUD {
    
    private let contentView = VideoDownloadProgressView.init()
    private var cancelClosure:(()->Void)?
    
    static let share = VideoDownloadHUD()
    
    init() {
        contentView.cancelClosure = { [unowned self] in
            HUD.hide()
            self.cancelClosure?()
        }
    }
    
    static func show(string: String, cancel: @escaping()->Void) {
        DispatchQueue.main.async {
            VideoDownloadHUD.share.contentView.titleLabel.text = string
            HUD.show(.customView(view: VideoDownloadHUD.share.contentView))
            VideoDownloadHUD.share.cancelClosure = cancel
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            HUD.hide()
        }
    }
}
