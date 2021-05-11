//
//  TabbarInteractionTransitionController.swift
//  ModalView
//
//  Created by miaokii on 2021/2/5.
//

import UIKit

class TabbarInteractionTransitionController: UIPercentDrivenInteractiveTransition {
    
    private var panGesture: UIPanGestureRecognizer
    private var transitionContext: UIViewControllerContextTransitioning?
    private var initTransitionInContainer = CGPoint.init()
    
    init(gesture: UIPanGestureRecognizer) {
        self.panGesture = gesture
        super.init()
        panGesture.addTarget(self, action: #selector(paned(sender:)))
    }
    
    deinit {
        panGesture.removeTarget(self, action: #selector(paned(sender:)))
    }
    
    @objc private func paned(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            return
        case .changed:
            let transitionPercent = percent(for: sender)
            if transitionPercent < 0 {
                cancel()
                panGesture.removeTarget(self, action: #selector(paned(sender:)))
            } else {
                update(transitionPercent)
            }
        case .ended:
            if percent(for: sender) >= 0.4 {
                finish()
            } else {
                cancel()
            }
        default:
            cancel()
        }
    }
    
    private func percent(for gesture: UIPanGestureRecognizer) -> CGFloat {
        guard let containerView = transitionContext?.containerView else {
            return 0
        }
        /// 偏移
        let nowTransition = gesture.translation(in: containerView)
        
        if nowTransition.x > 0, initTransitionInContainer.x < 0 ||
            nowTransition.x < 0, initTransitionInContainer.x > 0 {
            return -1
        }
        return abs(nowTransition.x)/containerView.bounds.width
    }
    
    /// 开始交互时，记录下首饰初始位置和偏移量，交互上下文，用来判断手势方向
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        self.initTransitionInContainer = panGesture.translation(in: transitionContext.containerView)
        super.startInteractiveTransition(transitionContext)
    }
}
