//
//  SwipeTransitionDelegate.swift
//  ModalView
//
//  Created by miaokii on 2021/2/3.
//

import UIKit

/// 滑动交互过渡
class SwipeTransitionDelegate: NSObject {
    /// 滑动手势
    var panGesture: UIScreenEdgePanGestureRecognizer!
    /// 滑动方向
    var edge: UIRectEdge!
}

extension SwipeTransitionDelegate: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SwipeTransitionAnimationor.init(edge: edge)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SwipeTransitionAnimationor.init(edge: edge)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return panGesture != nil ? SwipeInteractiveTransitionor.init(gesture: panGesture, target: edge) : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return panGesture != nil ? SwipeInteractiveTransitionor.init(gesture: panGesture, target: edge) : nil
    }
}

/// 交互类型过渡，根据手势决定toView的展示进度和是否取消（中途撤销）
fileprivate class SwipeInteractiveTransitionor: UIPercentDrivenInteractiveTransition {
    
    private weak var context: UIViewControllerContextTransitioning!
    private var panGesture: UIScreenEdgePanGestureRecognizer
    private var targetEdge: UIRectEdge
    
    init(gesture: UIScreenEdgePanGestureRecognizer, target edge: UIRectEdge) {
        assert(edge == .top ||
                edge == .bottom ||
                edge == .left ||
                edge == .right, "targetEdge must be one of top, bottom, left, or right")
        self.panGesture = gesture
        self.targetEdge = edge
        super.init()
        self.panGesture.addTarget(self, action: #selector(panGestureUpdate(sender:)))
    }
    
    deinit {
        panGesture.removeTarget(self, action: #selector(panGestureUpdate(sender:)))
    }
    
    @objc private func panGestureUpdate(sender: UIScreenEdgePanGestureRecognizer) {
        switch sender.state {
        case .began:
            break
        case .changed:
            update(percentFor(gesture: sender))
        case .ended:
            if percentFor(gesture: sender) >= 0.5 {
                finish()
            } else {
                cancel()
            }
        default:
            cancel()
        }
    }
    
    /// 获取滑动的进度
    private func percentFor(gesture: UIScreenEdgePanGestureRecognizer) -> CGFloat {
        guard context != nil else {
            return 0
        }
        let container = context.containerView
        // 手势移动点
        let point = gesture.location(in: container)
        
        let containerWidth = container.bounds.width
        let containerHeight = container.bounds.height
        
        switch targetEdge {
        case .right:
            return (containerWidth - point.x) / containerWidth
        case .bottom:
            return (containerHeight - point.y) / containerHeight
        case .left:
            return point.x / containerWidth
        case .top:
            return point.y / containerHeight
        default:
            return 0
        }
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        context = transitionContext
        super.startInteractiveTransition(transitionContext)
    }
}

/// 过渡动画
fileprivate class SwipeTransitionAnimationor: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var targetEdge: UIRectEdge
    
    init(edge: UIRectEdge) {
        targetEdge = edge
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVc = transitionContext.viewController(forKey: .to)
        else {
            return
        }
        
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        let container = transitionContext.containerView
        
        /// 正在展示
        let isPresenting = toVc.presentingViewController == fromVC
        
        let fromFrame = transitionContext.initialFrame(for: fromVC)
        let toFrame = transitionContext.finalFrame(for: toVc)
        
        var offset: CGVector = .zero
        switch targetEdge {
        case .top:
            offset = .init(dx: 0, dy: 1)
        case .bottom:
            offset = .init(dx: 0, dy: -1)
        case .left:
            offset = .init(dx: 1, dy: 0)
        case .right:
            offset = .init(dx: -1, dy: 0)
        default:
            assert(false, "targetEdge must be one of top, bottom, left, or right")
        }
        
        if isPresenting {
            if let toView = toView {
                container.addSubview(toView)
            }
            fromView?.frame = fromFrame
            toView?.frame = toFrame.offsetBy(dx: toFrame.size.width * offset.dx * -1,
                                            dy: toFrame.size.height * offset.dy * -1)
        } else {
            if let toView = toView, let fromView = fromView {
                container.insertSubview(toView, belowSubview: fromView)
            }
            fromView?.frame = fromFrame
            toView?.frame = toFrame
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            if isPresenting {
                toView?.frame = toFrame
            } else {
                fromView?.frame = fromFrame.offsetBy(dx: fromFrame.size.width * offset.dx,
                                                    dy: fromFrame.size.height * offset.dy)
            }
        } completion: { (_) in
            let cancel = transitionContext.transitionWasCancelled
            if cancel {
                toView?.removeFromSuperview()
            }
            transitionContext.completeTransition(!cancel)
        }
    }
}
