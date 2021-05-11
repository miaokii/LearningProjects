//
//  SwipeAViewController.swift
//  ModalView
//
//  Created by miaokii on 2021/2/3.
//

import UIKit

class SwipeAViewController: ModalViewController {

    /// 仅可识别是否从指定方向的屏幕边缘向内滑动的手势，继承自panGestrue
    private var panGesture: UIScreenEdgePanGestureRecognizer!
    private var swipeTransitionDelegate: SwipeTransitionDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        set(tag: "A")
        
        panGesture = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(screenEdgeGestureSwiped(sender:)))
        // 指定从右边划入
        panGesture.edges = .right
        view.addGestureRecognizer(panGesture)
        
        swipeTransitionDelegate = SwipeTransitionDelegate.init()
    }
    
    @objc private func screenEdgeGestureSwiped(sender: UIScreenEdgePanGestureRecognizer) {
        guard sender.state == .began else {
            return
        }
        presentBController(sender: sender)
    }
    
    override func presentNewController() {
        presentBController(sender: nextBtn)
    }
    
    private func presentBController(sender: Any?) {
        let vc = SwipeBViewController.init()
        if sender is UIPanGestureRecognizer {
            swipeTransitionDelegate.panGesture = panGesture
        } else {
            swipeTransitionDelegate.panGesture = nil
        }
        swipeTransitionDelegate.edge = panGesture.edges
        vc.transitioningDelegate = swipeTransitionDelegate
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
