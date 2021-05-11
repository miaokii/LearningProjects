//
//  FadeInOutAViewController.swift
//  ModalView
//
//  Created by miaokii on 2021/2/3.
//

import UIKit

class FadeInOutAViewController: ModalViewController {

    private var animator = FadeInOutAnimationTranstion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set(tag: "A")
    }
    
    override func presentNewController() {
        let vc = FadeInOutBViewController.init()
        vc.modalPresentationStyle = .fullScreen
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension FadeInOutAViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
}

class FadeInOutAnimationTranstion: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        /// 转场容器
        /// 当转场执行的时候，containerView只包含formView，不负责toView的添加
        /// 转场结束，containerView会将formView移除
        let animateContainer = transitionContext.containerView
        if let toView = toView {
            animateContainer.addSubview(toView)
        }
        
        fromView?.alpha = 1
        toView?.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            fromView?.alpha = 0
            toView?.alpha = 1
        } completion: { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
