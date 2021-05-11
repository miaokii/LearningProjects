//
//  TabbarTransitionDelegate.swift
//  ModalView
//
//  Created by miaokii on 2021/2/5.
//

import UIKit

class TabbarTransitionDelegate: NSObject {
    
    var panGesture: UIPanGestureRecognizer {
        return _panGesutre
    }
    
    private enum TabbarTransitionStyle: Int {
        case slide = 0
        case interactionSlide = 1
    }
    private lazy var _panGesutre: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureMoved(sender:)))
        tabbarController.view.addGestureRecognizer(gesture)
        return gesture
    }()
    private weak var tabbarController: UITabBarController!
    private var style: TabbarTransitionStyle = .slide
    
    init(tabbarController: UITabBarController) {
        super.init()
        self.tabbarController = tabbarController
        tabbarController.delegate = self
    }
    
    func set(style raw: Int) {
        self.style = TabbarTransitionStyle.init(rawValue: raw) ?? .slide
        _panGesutre.isEnabled  = style == .interactionSlide
    }
    
    @objc private func panGestureMoved(sender: UIPanGestureRecognizer) {
        // 当没有过渡事件才可以滑动
        guard tabbarController.transitionCoordinator == nil else {
            return
        }
        
        // 开始滑动或者 滑动中
        guard sender.state == .began || sender.state == .changed else {
            return
        }
        
        panded(gesture: sender)
    }
    
    private func panded(gesture: UIPanGestureRecognizer) {
        /// 从开始滑动点到当前手势点的位移
        let translation = gesture.translation(in: tabbarController.view)
        let controllerCount = tabbarController.viewControllers?.count ?? 0
        
        // 向右滑，tabbar向左切换
        if translation.x > 0, tabbarController.selectedIndex > 0 {
            tabbarController.selectedIndex -= 1
        }
        // 向左滑，tabbar向右切换
        else if translation.x < 0, tabbarController.selectedIndex + 1 < controllerCount {
            tabbarController.selectedIndex += 1
        }
        else {
            if translation != .zero {
                gesture.isEnabled = false
                gesture.isEnabled = true
            }
        }
        
        tabbarController.transitionCoordinator?.animate(alongsideTransition: nil, completion: { (context) in
            if context.isCancelled, gesture.state == .changed {
                self.panded(gesture: gesture)
            }
        })
    }
}

extension TabbarTransitionDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard panGesture.state == .began || panGesture.state == .changed else {
            return nil
        }
        return TabbarInteractionTransitionController.init(gesture: _panGesutre)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        _panGesutre.isEnabled  = style == .interactionSlide
        guard let fromIndex = tabbarController.viewControllers?.firstIndex(of: fromVC),
              let toIndex = tabbarController.viewControllers?.firstIndex(of: toVC) else {
            return nil
        }
        let targetEdge: UIRectEdge = fromIndex < toIndex ? .left : .right
        return TabbarTransitionAnimator.init(target: targetEdge)
    }
}
