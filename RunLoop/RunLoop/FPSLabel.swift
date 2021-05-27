//
//  FPSLabel.swift
//  RunLoop
//
//  Created by miaokii on 2021/5/25.
//

import UIKit

fileprivate let FPSSize: CGSize = .init(width: 60, height: 20)
class FPSLabel: UILabel {
    
    private var displayLink: CADisplayLink!
    private var lastTimeStamp: CFTimeInterval = 0
    private var fpsCount = 0
    
    override init(frame: CGRect) {
        var rect = frame
        if rect.size == .zero {
            rect.size = FPSSize
        }
        super.init(frame: rect)
        setup()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return FPSSize
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        layer.cornerRadius = 5
        clipsToBounds = true
        textAlignment = .center
        isUserInteractionEnabled = false
        
        displayLink = CADisplayLink.init(target: WeakProxy.init(target: self), selector: #selector(displayLinkTrigger))
        displayLink.add(to: RunLoop.current, forMode: .common)
    }
    
    @objc private func displayLinkTrigger() {
        
        guard lastTimeStamp > 0 else {
            lastTimeStamp = displayLink.timestamp
            return
        }
        fpsCount += 1
        let delta = displayLink.timestamp - lastTimeStamp
        if delta < 1 { return }
        lastTimeStamp = displayLink.timestamp
        let fps: Double = Double(fpsCount)/delta
        fpsCount = 0
        
        /// 流畅度 0-1
        let percent = fps/60.0
        let color = UIColor.init(hue: CGFloat(0.27*(percent-0.2)), saturation: 1, brightness: 0.9, alpha: 1)
        
        let attributeString = NSMutableAttributedString.init(string: String.init(format: "%d FPS", Int(round(fps))))
        attributeString.setAttributes([.foregroundColor: color], range: .init(location: 0, length: attributeString.length-3))
        attributeString.setAttributes([.foregroundColor: UIColor.white], range: .init(location: attributeString.length-3, length: 3))
        attributedText = attributeString
    }
}

class WeakProxy: NSObject {
    private weak var target: NSObject?
    
    init(target: NSObject) {
        super.init()
        self.target = target
    }
    
    /// 消息转发流程
    override class func resolveInstanceMethod(_ sel: Selector!) -> Bool {
        return super.resolveInstanceMethod(sel)
    }
    
    /// 返回接收消息的备用者
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let obj = target, obj.responds(to:aSelector) {
            return target
        }
        return super.forwardingTarget(for:aSelector)
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        if let obj = target {
            return obj.responds(to: aSelector)
        }
        return false
    }
}

extension UIWindow {
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
}
