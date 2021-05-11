//
//  TransitionNavigationController.swift
//  ModalView
//
//  Created by miaokii on 2021/1/28.
//

import UIKit

class TransitionNavigationController: NavigationViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension TransitionNavigationController: UINavigationControllerDelegate {
    
    /// 在controller切换时的交互动画
    /// - Parameters:
    ///   - navigationController: 发生controller切换的navigationController
    ///   - animationController: 由navigationController(_:animationControllerFor:from:to:)方法提供的非交互式动画对象
    /// - Returns: 过度动画的对象，需要实现UIViewControllerInteractiveTransitioning协议，如果使用默认过渡动画，返回nil
    ///
    /// - 当您想在视图控制器添加到导航堆栈或从导航堆栈中删除时，在视图控制器之间提供自定义的交互式过渡时，请实现此委托方法。 返回的对象应配置过渡的交互性，并应与animationController参数中的对象一起启动动画。
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    /// controller切换时的非交互式动画对象
    /// - Parameters:
    ///   - navigationController: 发生controller切换的navigationController
    ///   - operation: 引起过渡发生的操作类型 push、pop
    ///   - fromVC: 当前可见的controller
    ///   - toVC: 过渡结束时可见的控制器
    /// - Returns: 负责管理过渡动画的动画对象，如果要使用标准导航控制器过渡，则为nil
    ///
    /// - 当您要在视图控制器添加到导航堆栈或从导航堆栈中删除时，在它们之间提供自定义动画过渡时，请实现此委托方法
    /// - 您返回的对象应该能够在固定的时间内针对指定的操作类型为指定的视图控制器配置和执行非交互式动画
    /// - 如果要允许用户执行交互式转换，则还必须实现navigationController（_：interactionControllerFor :)方法
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return MKNavgationAnimatedTransition.init()
        default:
            return nil
        }
    }
}


/// 过度动画对象
fileprivate class MKNavgationAnimatedTransition:NSObject, UIViewControllerAnimatedTransitioning {
    /*
     定义动画对象，以创建动画并在固定的时间内在屏幕上或屏幕外转换视图控制器
     该动画不能是交互式的
     若要创建交互式转场，必须将动画对象与另一个控制动画时间的对象结合在一起
     */
    
    /// 转场动画持续时间s
    /// - Parameter transitionContext: 转场上下文，包含转场过渡期间的信息
    /// - Returns: 持续时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    /// 执行过度动画
    /// - Parameter transitionContext: 过渡的上下文
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        /// 旧的控制器
        guard let formView = transitionContext.viewController(forKey: .from)?.view,
        /// 新的控制器
              let toView = transitionContext.viewController(forKey: .to)?.view else {
            return
        }
        /// 转场容器
        /// 当转场执行的时候，containerView只包含formView，不负责toView的添加
        /// 转场结束，containerView会将formView移除
        let animateContainer = transitionContext.containerView
        animateContainer.addSubview(toView)
        animateContainer.bringSubviewToFront(formView)
        
        toView.alpha = 0
        toView.transform = CGAffineTransform.init(translationX: -MKDefine.screenWidth, y: 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseIn) {
            formView.alpha = 0
            formView.transform = CGAffineTransform.init(translationX: MKDefine.screenWidth, y: 0)
            toView.alpha = 1
            toView.transform = .identity
        } completion: { (_) in
            formView.transform = .identity
            formView.alpha = 1
            /// 在非交互转场中，动画结束之后需要执行transitionContext.completeTransition(!transitionContext.transitionWasCancelled)（如果动画被取消，传NO）
            /// 在interactive交互转场中，动画是否结束是由外界控制的（用户行为或者特定函数），需要在外部调用
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    /*
    /// 返回过渡期间使用的可中断动画
    /// - Parameter transitionContext: 过渡的上下文
    /// - Returns: 可以修改的动画对象
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        
    }
 */
    
    /// 动画执行结束，新的视图控制器已经呈现返回true，中途取消转场返回false
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
}

/// 定义转场
fileprivate class MKNavigationTransition: NSObject, UIViewControllerInteractiveTransitioning {
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
    }
}

