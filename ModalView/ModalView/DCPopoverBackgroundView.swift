//
//  DCPopoverBackgroundView.swift
//  businessManagement
//
//  Created by fighter on 2020/11/6.
//  Copyright © 2020 fighter. All rights reserved.
//

import UIKit

class DCPopoverBackgroundViewConfiguration {
    static let share = DCPopoverBackgroundViewConfiguration()
    var arrowBase: CGFloat = 15
    var arrowHeight: CGFloat = 13
    var contentViewInsets: UIEdgeInsets = .zero
    var backgroundColor: UIColor = .white
    var cornerRadius: CGFloat = 0
    
    private init() {}
}

class DCPopoverBackgroundView: UIPopoverBackgroundView {
    private var _arrowOffset: CGFloat = 0
    private var _arrowDirection: UIPopoverArrowDirection = .up
    private let arrowImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(arrowImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func arrowBase() -> CGFloat {
        DCPopoverBackgroundViewConfiguration.share.arrowBase
    }
    
    override class func arrowHeight() -> CGFloat {
        DCPopoverBackgroundViewConfiguration.share.arrowHeight
    }
    
    override class func contentViewInsets() -> UIEdgeInsets {
        DCPopoverBackgroundViewConfiguration.share.contentViewInsets
    }
    
    override var arrowOffset: CGFloat {
        set {
            _arrowOffset = newValue
        }
        get {
            _arrowOffset
        }
    }
    
    override var arrowDirection: UIPopoverArrowDirection {
        set {
            _arrowDirection = newValue
        }
        get {
            _arrowDirection
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowOpacity = 0
        
        //更改箭头位置
        let arrowSize = CGSize(width: DCPopoverBackgroundViewConfiguration.share.arrowBase, height: DCPopoverBackgroundViewConfiguration.share.arrowHeight)
        arrowImageView.image = drawArrowImage(size: arrowSize)

        let x: CGFloat
        let y: CGFloat
        
        let width = bounds.width
        let height = bounds.height
        let arrowWidth = arrowSize.width
        let arrowHeight = arrowSize.height
        
        switch _arrowDirection {
        case .up:
                x = (width - arrowWidth) / 2 + _arrowOffset
                y = 0
        case .left:
                x = 0
                y = (height - arrowHeight) / 2 + _arrowOffset
        case .down:
                x = (width - arrowWidth) / 2 + _arrowOffset
                y = height - arrowHeight
        case .right:
                x = width - arrowWidth
                y = (height - arrowHeight) / 2 + _arrowOffset
        default://UIPopoverArrowDirectionAny忽略
                x = 0
                y = 0
        }
        
        arrowImageView.frame = CGRect(x: x, y: y, width: arrowSize.width, height: arrowSize.height)
        
        superview?.subviews.filter({ $0 != self }).forEach({
            $0.layer.cornerRadius = DCPopoverBackgroundViewConfiguration.share.cornerRadius
            $0.backgroundColor = DCPopoverBackgroundViewConfiguration.share.backgroundColor
        })
        
        var nextResponder = superview
        repeat {
            if nextResponder?.superview is UIWindow {
                break
            }
            nextResponder = nextResponder?.superview
        } while nextResponder != nil
        
        nextResponder?.alpha = 0
        UIView.animate(withDuration: 0.2) {
            nextResponder?.alpha = 1
        } completion: { (_) in
            
        }
        
        guard let _UICutoutShadowView = NSClassFromString("_UICutoutShadowView") else { return }
        superview?.superview?.subviews.forEach({
            guard $0.isKind(of: _UICutoutShadowView) else { return }
            $0.removeFromSuperview()
        })
    }
    
    //绘制箭头图片
    private func drawArrowImage(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        UIColor.clear.setFill()
        context?.fill(CGRect(origin: .zero, size: size))
        
        let point1: CGPoint
        let point2: CGPoint
        let point3: CGPoint
        
        switch _arrowDirection {
        case .up:
            point1 = CGPoint(x: size.width / 2, y: 0)
            point2 = CGPoint(x: size.width, y: size.height)
            point3 = CGPoint(x: 0, y: size.height)
        case .left:
            point1 = CGPoint(x: 0, y: size.height / 2)
            point2 = CGPoint(x: size.width, y: size.height)
            point3 = CGPoint(x: size.width, y: 0)
        case .down:
            point1 = CGPoint(x: 0, y: 0)
            point2 = CGPoint(x: size.width / 2, y: size.height)
            point3 = CGPoint(x: size.width, y: 0)
        case .right:
            point1 = CGPoint(x: 0, y: 0)
            point2 = CGPoint(x: size.width, y: size.height / 2)
            point3 = CGPoint(x: 0, y: size.height)
        default:
            point1 = .zero
            point2 = .zero
            point3 = .zero
        }
        
        let arrowPath = CGMutablePath()
        arrowPath.move(to: point1)
        arrowPath.addLine(to: point2)
        arrowPath.addLine(to: point3)
        arrowPath.closeSubpath()
        context?.addPath(arrowPath)
        context?.setFillColor(DCPopoverBackgroundViewConfiguration.share.backgroundColor.cgColor)
        context?.drawPath(using: .fill)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard #available(iOS 13.0, *), previousTraitCollection?.hasDifferentColorAppearance(comparedTo: traitCollection) ?? false, UIApplication.shared.applicationState != .background, let image = arrowImageView.image else { return }
        
        arrowImageView.image = image.withTintColor(DCPopoverBackgroundViewConfiguration.share.backgroundColor)
    }
}
