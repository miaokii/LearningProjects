//
//  SwipeBViewController.swift
//  ModalView
//
//  Created by miaokii on 2021/2/3.
//

import UIKit

class SwipeBViewController: ModalViewController {

    private var panGesture: UIScreenEdgePanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        set(tag: "B")
        nextBtn.isHidden = true
        view.backgroundColor = .random
        panGesture = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(panExit))
        panGesture.edges = .left
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func panExit() {
        guard panGesture.state == .began else {
            return
        }
        pop(sender: panGesture)
    }
    
    override func popOrDismiss() {
        pop(sender: nil)
    }

    private func pop(sender: Any?) {
        guard let transitionDeleagte = transitioningDelegate as? SwipeTransitionDelegate else {
            return
        }
        if sender is UIPanGestureRecognizer {
            transitionDeleagte.panGesture = panGesture
        } else {
            transitionDeleagte.panGesture = nil
        }
        transitionDeleagte.edge = .left
        super.popOrDismiss()
    }
}
