//
//  TransitionAnimationController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/22.
//

import UIKit
import MKSwiftRes

/*
 隐式过渡
 过渡CATransition
    CATransition不作用于指定图层的属性，而是作用于整个图层树
    要保证CATransition添加的图层不会在过渡发生时从图层树移除，否则CATransition会一起被移除
    所以CATransition应该添加到被影响图层的superLayer
 */
class TransitionAnimationController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controllers: [UIViewController] = [TransitionImageController(), TransitionImageController()]
        for vc in controllers {
            vc.view.backgroundColor = .random
            let tabbarItem = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 0)
            vc.tabBarItem = tabbarItem
        }
        delegate = self
        self.viewControllers = controllers
    }
}

extension TransitionAnimationController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let transition = CATransition.init()
        transition.type = .push
        tabBarController.view.layer.add(transition, forKey: nil)
    }
}


fileprivate class TransitionImageController: MKViewController {
    private var images: [UIImage] = [
        UIImage.init(named: "juzi")!,
        UIImage.init(named: "chun")!,
        UIImage.init(named: "cat")!]
    private var imageView : UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView.init(super: view, backgroundColor: .clear)
        imageView.image = images[0]
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.8)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
            make.height.equalTo(imageView.snp.width)
        }
        
        let chageImage = UIButton.themeBtn(super: view, title: "Change Image")
        chageImage.setClosure { (_) in
            self.uiViewTransition()
        }
        chageImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(40)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(40)
        }
    }
    
    private func catransition() {
        let i = self.images.firstIndex(of: imageView.image!)!
        let next = (i+1)%self.images.count
        
        let transition = CATransition.init()
        transition.type = .fade
        imageView.layer.add(transition, forKey: nil)
        imageView.image = self.images[next]
    }
    
    private func uiViewTransition() {
        UIView.transition(with: imageView, duration: 1, options: .transitionFlipFromLeft) {
            let i = self.images.firstIndex(of: self.imageView.image!)!
            let next = (i+1)%self.images.count
            self.imageView.image = self.images[next]
        } completion: { (_) in }

    }
}
