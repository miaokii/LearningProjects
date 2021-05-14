//
//  HUD.swift
//  DoctorProject
//
//  Created by miaokii on 2020/7/30.
//  Copyright © 2020 Ly. All rights reserved.

import Foundation
import MBProgressHUD

/// MBProgressHUD的封装类，用法同PKHUD
/// 同时适配了暗黑模式
class HUD {
    
    /// 进度条类型
    enum HUDDeterminateStyle {
        /// 环形
        case normal
        /// 内切环形
        case annular
        /// 水平进度条
        case horizontalBar
    }
    
    /// HUD类型
    enum HUDContentType {
        /// 成功 √
        case success
        /// 失败 ×
        case error
        /// 指示器，菊花
        case indicator
        /// 进度条
        case determinate(progress: Float, style: HUDDeterminateStyle)
        /// 显示图片
        case image(UIImage?)
        /// 旋转图片，clockwise顺时针
        case rotatingImage(UIImage?, clockwise: Bool)
        /// 文本成功
        case labelSuccess(title: String?, detail: String?)
        /// 文本失败
        case labelError(title: String?, detail: String?)
        /// 文本警告
        case labelWarning(title: String?, detail: String?)
        /// 文本指示器，菊花
        case labelIndicator(title: String?, detail: String?)
        /// 文本进度条
        case labelDeterminate(progress: Float, style: HUDDeterminateStyle, title: String?)
        /// 文本图片
        case labelImage(image: UIImage?, title: String?, detail: String?)
        /// 文本旋转图片
        case labelRotatingImage(image: UIImage?, clockwise: Bool, title: String?, detail: String?)

        /// 只显示文本
        case label(String?)
        /// 自定义内容
        case customView(view: UIView)
    }
    
    /// 持有的hud
    private var hud: MBProgressHUD!
    /// 默认显示hud的父视图
    private var window: UIWindow {
            return UIApplication.shared.keyWindow!
    }

    /// 单例
    static var share: HUD! {
        struct Static {
            static let instance: HUD = HUD()
        }
        return Static.instance
    }
    
    /// 背景风格
    static var bgStyle: MBProgressHUDBackgroundStyle = .solidColor
    /// 浅色模式背景颜色
    static var lightBgColor: UIColor = .init(0xf2f2f2)
    /// 浅色模式内容颜色
    static var lightContentColor: UIColor = .gray
    /// 暗黑模式背景颜色
    static var darkBgColor: UIColor = .init(0x1E2028)
    /// 暗黑模式内容颜色
    static var darkContentColor: UIColor = .init(0xf2f2f2)
    /// 阴影颜色，nil不显示阴影
    static var bgShadowColor: UIColor? = nil
    /// 是否适配暗黑模式
    static var enableDarkMode = true
    /// 蒙板颜色
    static var dimBgColor: UIColor? = nil
    /// 默认消失时间
    static var delaySec = 1.5
    
    /// 当不适配暗黑模式时的
    /// 默认的背景颜色
    static var bgColor: UIColor = .init(0xf2f2f2)
    
    /// 当不适配暗黑模式时的
    /// 默认的内容颜色
    static var contentColor: UIColor = .gray
    
    /// 当进度完成时，是否隐藏hud
    static var determinateHideOnProgressComplete = true
}

extension HUD {
    
    /// 提示错误
    /// - Parameters:
    ///   - error: 错误
    ///   - onView: 显示的父视图
    ///   - delay: 显示的延迟时间
    class func flash(error: Swift.Error?, onView: UIView? = nil, delay: TimeInterval = delaySec, completion: (()->Void)? = nil) {
        HUD.flash(error: nil, detail: error?.localizedDescription, onView: onView, delay: delay, completion: completion)
    }
    
    /// 提示错误
    /// - Parameters:
    ///   - error: 错误内容
    ///   - detail: 描述
    ///   - onView: 父视图
    ///   - delay: 延迟时间
    class func flash(error: String?, detail: String? = nil, onView: UIView? = nil, delay: TimeInterval = delaySec, completion: (()->Void)? = nil) {
        HUD.flash(.labelError(title: error, detail: detail), onView: onView, delay: delay, completion: completion)
    }
    
    /// 提示成功
    /// - Parameters:
    ///   - success: 成功标题
    ///   - detail: 成功描述
    ///   - onView: 父视图
    ///   - delay: 延迟时间
    class func flash(success: String?, detail: String? = nil, onView: UIView? = nil, delay: TimeInterval = delaySec, completion: (()->Void)? = nil) {
        HUD.flash(.labelSuccess(title: success, detail: detail), onView: onView, delay: delay, completion: completion)
    }
    
    /// 提示警告
    /// - Parameters:
    ///   - warning: 警告标题
    ///   - detail: 警告描述
    ///   - onView: 父视图
    ///   - delay: 延迟时间
    class func flash(warning: String, detail: String? = nil, onView: UIView? = nil, delay: TimeInterval = delaySec, completion: (()->Void)? = nil) {
        HUD.flash(.labelWarning(title: warning, detail: detail), onView: onView, delay: delay, completion: completion)
    }
    
    /// 显示加载菊花
    /// - Parameters:
    ///   - title: 标题
    ///   - detail: 描述
    ///   - onView: 父视图
    class func show(title: String? = nil, detail: String? = nil, onView: UIView? = nil) {
        HUD.show(.labelIndicator(title: title, detail: detail), onView: onView)
    }
    
    /// 提示一条文本信息
    /// - Parameters:
    ///   - hint: 提示内容
    ///   - onView: 父视图
    ///   - delay: 延迟时间
    class func flash(hint: String?, onView: UIView? = nil, delay: TimeInterval = delaySec) {
        HUD.flash(.label(hint), onView: onView, delay: delay)
    }
}

extension HUD {
    
    /// 隐藏hud
    /// - Parameters:
    ///   - delay: 延迟时间
    ///   - completion: 隐藏后的回调
    class func hide(delay: TimeInterval = 0, completion: (()->Void)? = nil) {
        DispatchQueue.main.async {
            guard share.hud != nil, !share.hud.isHidden else {
                completion?()
                return
            }
            
            if let completionBlock = completion {
                share.hud.completionBlock = completionBlock
            }
            share.hud.hide(animated: delay >= 0, afterDelay: delay)
        }
    }
    
    /// 显示hud，需要自己控制隐藏
    /// - Parameters:
    ///   - content: hud类型
    ///   - onView: 父视图
    class func show(_ content: HUDContentType, onView: UIView? = nil) {
        switch content {
        case .success:
            show(.labelSuccess(title: nil, detail: nil), onView: onView)
            
        case let .labelSuccess(title, detail):
            let successView = UIImageView.init(image: UIImage.init(named: "done")?.withRenderingMode(.alwaysTemplate))
            share.customHUD(view: successView, title: title, detail: detail, onView: onView)
            
        case .error:
            show(.labelError(title: nil, detail: nil), onView: onView)
            
        case let .labelError(title, detail):
            let errorView = UIImageView.init(image: UIImage.init(named: "error")?.withRenderingMode(.alwaysTemplate))
            share.customHUD(view: errorView, title: title, detail: detail, onView: onView)
            
        case let .labelWarning(title, detail):
            let errorView = UIImageView.init(image: UIImage.init(named: "warning")?.withRenderingMode(.alwaysTemplate))
            share.customHUD(view: errorView, title: title, detail: detail, onView: onView)
            
        case .label(let text):
            share.textHUD(text: text, onView: onView)
            
        case let .determinate(progress, style):
            show(.labelDeterminate(progress: progress, style: style, title: nil), onView: onView)
            
        case let .labelDeterminate(progress, style, title):
            share.determinateHUD(progress: progress, style: style, title: title, onView: onView)
            
        case .indicator:
            show(.labelIndicator(title: nil, detail: nil), onView: onView)
        
        case let .labelIndicator(title, detail):
            share.indicatorHUD(title: title, detail: detail, onView: onView)
            
        case .image(let image):
            show(.labelImage(image: image, title: nil, detail: nil), onView: onView)
            
        case let .labelImage(image, title, detail):
            let imageView = UIImageView.init(image: image?.withRenderingMode(.alwaysTemplate))
            share.customHUD(view: imageView, title: title, detail: detail, onView: onView)
            
        case let .rotatingImage(image, clockwise):
            show(.labelRotatingImage(image: image, clockwise: clockwise, title: nil, detail: nil), onView: onView)
            
        case let .labelRotatingImage(image, clockwise, title, detail):
            let imageView = UIImageView.init(image: image?.withRenderingMode(.alwaysTemplate))
            imageView.layer.add(HUD.rotationAnimation(clockwise), forKey: "progressAnimation")
            share.customHUD(view: imageView, title: title, detail: detail, onView: onView)
            
        case .customView(let view):
            share.customHUD(view: view, onView: onView)
        }
    }
    
    /// 提示hud，默认会在延迟delaySec秒后消失，delaySec可配置
    /// - Parameters:
    ///   - content: hud类型
    ///   - onView: 父视图
    ///   - delay: 延迟时间
    class func flash(_ content: HUDContentType, onView: UIView? = nil, delay: TimeInterval = delaySec, completion: (()->Void)? = nil) {
        show(content, onView: onView)
        hide(delay: delay, completion: completion)
    }
}

extension HUD {
    
    private static func rotationAnimation(_ clockwise: Bool) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = 2.0 * .pi * (clockwise ? 1 : -1)
        animation.duration = 1.2
        animation.repeatCount = Float(INT_MAX)
        return animation
    }
    
    private func configHUD(onView: UIView?, mode: MBProgressHUDMode = .indeterminate) {
        let hudView = onView ?? window
        
        // 确保始终只显示一个hud
        if hud == nil {
            hud = MBProgressHUD.showAdded(to: hudView, animated: true)
        } else {
            /// 保证同一个视图是指存在一个hud
            if let cur_hud = MBProgressHUD.hud(for: hudView), cur_hud != hud {
                hud = cur_hud
            }
            hud.removeFromSuperview()
            hud = MBProgressHUD.showAdded(to: hudView, animated: true)
        }
        
        hud.removeFromSuperViewOnHide = true
        hud.mode = mode
        hud.bezelView.style = HUD.bgStyle
        
        if let disColor = HUD.dimBgColor {
            hud.backgroundView.color = disColor
        }
        
        if let sColor = HUD.bgShadowColor {
            hud.bezelView.layer.shadowColor = sColor.cgColor
            hud.bezelView.layer.shadowOffset = CGSize.zero
            hud.bezelView.layer.shadowOpacity = 0.4
            hud.bezelView.clipsToBounds = false
        }
        
        if #available(iOS 13.0, *), HUD.enableDarkMode {
            hud.contentColor = .init(light: HUD.lightContentColor, dark: HUD.darkContentColor)
            hud.bezelView.color = .init(light: HUD.lightBgColor, dark: HUD.darkBgColor)
        } else {
            hud.contentColor = HUD.contentColor
            hud.bezelView.color = HUD.bgColor
        }
        
        switch mode {
        case .text:
            hud.offset = .init(x: 0, y: hud.frame.height * 0.5 * 0.7)
        default:
            hud.offset = .zero
        }
    }
    
    private func indicatorHUD(title: String? = nil, detail: String? = nil, onView: UIView? = nil) {
        DispatchQueue.main.async {
            self.configHUD(onView: onView, mode: .indeterminate)
            self.hud.label.text = title
            self.hud.detailsLabel.text = detail
        }
    }
    
    private func customHUD(view: UIView, title: String? = nil, detail: String? = nil, onView: UIView? = nil) {
        DispatchQueue.main.async {
            self.configHUD(onView: onView, mode: .customView)
            self.hud.customView = view
            self.hud.mode = .customView
            self.hud.label.text = title
            self.hud.detailsLabel.text = detail
        }
    }
    
    private func textHUD(text: String?, onView: UIView? = nil) {
        DispatchQueue.main.async {
            self.configHUD(onView: onView, mode: .text)
            self.hud.label.text = text
            self.hud.label.numberOfLines = 5
        }
    }
    
    private func determinateHUD(progress: Float, style: HUDDeterminateStyle, title: String? = nil, onView: UIView? = nil) {
        DispatchQueue.main.async {
            let mode: MBProgressHUDMode = (style == .normal ? .annularDeterminate : (style == .horizontalBar ? .determinateHorizontalBar : .determinate))

            if let deterHUD = MBProgressHUD.hud(for: onView ?? self.window), self.hud == deterHUD {
                self.hud.mode = mode
                self.hud.progress = progress
                self.hud.label.text = title
                if (progress >= 1), HUD.determinateHideOnProgressComplete {
                    HUD.hide()
                }
            } else if self.hud == nil {
                self.configHUD(onView: onView, mode: mode)
                self.hud.progress = progress
                self.hud.label.text = title
            } else {
                HUD.hide {
                    HUD.share.configHUD(onView: onView, mode: mode)
                    HUD.share.hud.progress = progress
                    HUD.share.hud.label.text = title
                }
            }
        }
    }
}

extension MBProgressHUD {
    @discardableResult
    static func hideHUD(for view: UIView, animated: Bool) -> Bool {
        guard let hud = hud(for: view) else {
            return false
        }
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true)
        return true
    }
    
    static func hud(for view: UIView) -> MBProgressHUD? {
        let subViewsEnum = view.subviews.reversed()
        for subView in subViewsEnum {
            guard let hud = subView as? MBProgressHUD else {
                continue
            }
            return hud
        }
        return nil
    }
}

extension UIColor {
    fileprivate convenience init(light: UIColor, dark: UIColor? = nil) {
        if #available(iOS 13.0, *) {
            if dark == nil {
                var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
                light.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                
                self.init(dynamicProvider: { $0.userInterfaceStyle == .light ? light : UIColor(red: 1 - red, green: 1 - green, blue: 1 - blue, alpha: alpha) })
            } else {
                self.init(dynamicProvider: { $0.userInterfaceStyle == .light ? light : dark! })
            }
        } else {
            self.init(cgColor: light.cgColor)
        }
    }
}

