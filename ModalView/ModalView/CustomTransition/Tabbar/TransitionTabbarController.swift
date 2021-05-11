//
//  TransitionTabbarController.swift
//  ModalView
//
//  Created by miaokii on 2021/2/1.
//

import UIKit

protocol MKTabbarAnimationTranstionDelegate {
    var controllers: [UIViewController] { get set }
}

class TransitionTabbarController: UITabBarController {
        
    private var titles = ["历史", "书签", "设置"]
    private var segmentView: UISegmentedControl!
    private var tansitionDeleagte: TabbarTransitionDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tansitionDeleagte = .init(tabbarController: self)
        
        let vcs: [ItemViewController] = [ItemViewController(), ItemViewController(), ItemViewController()]
        var navs = [ItemNavigatoinController]()
        let images: [UIImage] = [.actions, .actions, .actions]
        
        for i in 0..<titles.count {
            let vc = vcs[i]
            vc.title = titles[i]
            vc.index = i
            
            let tabBarItem = UITabBarItem()
            tabBarItem.title = titles[i]
            tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 11), .foregroundColor: UIColor.lightGray], for: .normal)
            tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 11), .foregroundColor: UIColor.blue], for: .selected)
            tabBarItem.image = images[i].withTintColor(.lightGray)
            tabBarItem.selectedImage = images[i].withTintColor(.blue)
            
            let nav = ItemNavigatoinController.init(rootViewController: vc)
            nav.tabBarItem = tabBarItem
            navs.append(nav)
        }
        
        viewControllers = navs
        tabBar.isTranslucent = false
        
        if #available(iOS 13, *) {
            let appearance = tabBar.standardAppearance.copy()
            appearance.shadowColor = .table_bg
            appearance.backgroundColor = .view_l1
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 11), .foregroundColor: UIColor.lightGray]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 11), .foregroundColor: UIColor.blue]
            tabBar.standardAppearance = appearance
        } else {
            tabBar.backgroundImage = UIImage()
            tabBar.shadowImage = .init()
            tabBar.backgroundColor = .view_l1
        }
        
        segmentView = UISegmentedControl.init(items: ["滑动效果", "滑动手势交互"])
        segmentView.selectedSegmentTintColor = .white
        segmentView.backgroundColor = .table_bg
        segmentView.selectedSegmentIndex = 0
        navigationItem.titleView = segmentView
        segmentView.addTarget(self, action: #selector(segmentChange), for: .valueChanged)
    }
    
    @objc private func segmentChange() {
        tansitionDeleagte.set(style: segmentView.selectedSegmentIndex)
    }
}
