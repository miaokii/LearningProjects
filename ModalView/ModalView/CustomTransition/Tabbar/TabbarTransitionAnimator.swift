//
//  TabbarTransitionAnimator.swift
//  ModalView
//
//  Created by miaokii on 2021/2/4.
//

import UIKit

/// 无交互动画
class TabbarTransitionAnimator:NSObject, UIViewControllerAnimatedTransitioning {
    
    /// 滑动方向
    private var targetEdge: UIRectEdge = .left
    
    init(target edge: UIRectEdge) {
        super.init()
        assert(edge == .left || edge == .right, "edge must be one of left or right")
        targetEdge = edge
    }
    
    /*
     定义动画对象，以创建动画并在固定的时间内在屏幕上或屏幕外转换视图控制器
     该动画不能是交互式的
     若要创建交互式转场，必须将动画对象与另一个控制动画时间的对象结合在一起
     */
    
    /// 转场动画持续时间s
    /// - Parameter transitionContext: 转场上下文，包含转场过渡期间的信息
    /// - Returns: 持续时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    /// 执行过度动画
    /// - Parameter transitionContext: 过渡的上下文
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        /// 旧的控制器
        guard let fromVC = transitionContext.viewController(forKey: .from),
        /// 新的控制器
              let toVC = transitionContext.viewController(forKey: .to)
        else {
            return
        }
        
        let animateContainer = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        var fromFrame = transitionContext.initialFrame(for: fromVC)
        let toFrame = transitionContext.finalFrame(for: toVC)
        
        if let toView = toView {
            animateContainer.addSubview(toView)
        }
        
        let containerWidth = animateContainer.bounds.width
        toView?.frame = toFrame.offsetBy(dx: targetEdge == .left ? containerWidth : -containerWidth, dy: 0)
        fromFrame = fromFrame.offsetBy(dx: targetEdge == .left ? -containerWidth : containerWidth, dy: 0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: .curveEaseInOut) {
            toView?.frame = toFrame
            fromView?.frame = fromFrame
        } completion: { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        
        /*
        let formView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        /// 转场容器
        /// 当转场执行的时候，containerView只包含formView，不负责toView的添加
        /// 转场结束，containerView会将formView移除
        let animateContainer = transitionContext.containerView
        
        let toTranslationX = CGFloat(targetEdge == .right ? -1 : 1) * MKDefine.screenWidth
        let fromTranslationX = -toTranslationX
        
        /// 添加toView到animateContainer
        if let toView = toView {
            animateContainer.addSubview(toView)
            toView.transform = CGAffineTransform.init(translationX: toTranslationX, y: 0)
        }

        /// 过度时间
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveLinear) {
            formView?.transform = CGAffineTransform.init(translationX: fromTranslationX, y: 0)
            toView?.transform = .identity
        } completion: { (_) in
            formView?.transform = .identity
            /// 在非交互转场中，动画结束之后需要执行transitionContext.completeTransition(!transitionContext.transitionWasCancelled)（如果动画被取消，传NO）
            /// 在interactive交互转场中，动画是否结束是由外界控制的（用户行为或者特定函数），需要在外部调用
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        */
    }
}
