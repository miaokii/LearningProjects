//
//  FirstViewController.swift
//  ModalView
//
//  Created by miaokii on 2021/1/27.
//

import UIKit

class FirstViewController: UIViewController {

    private var alertVC: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightItem = UIBarButtonItem.init(title: "alert", style: .done, target: self, action: #selector(showPop))
        navigationItem.rightBarButtonItem = rightItem
        
        alertVC = UIAlertController.init(title: "设置", message: "输入设置内容", preferredStyle: .alert)
        alertVC.addAction(.init(title: "确认", style: .default, handler: nil))

        /*
         当firstController添加在window上，实际的栈结构为：
         window/UITransitionView/UIDropShadowView/firstController
         */
        
        /*
        presentingViewController指的是 present 出当前控制器的控制器。
        presentedViewController指被当前控制器 present 出的控制器。
         */
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }

    @objc private func showPop() {
        
    }
    
    var vc: UIViewController = SecondController.init()
    @IBAction func presentController(_ sender: UIButton) {
//        var vc = UIViewController.init()
        // present controller时的模态样式
        guard let presentationStyle = UIModalPresentationStyle.init(rawValue: sender.tag) else {
            return
        }

        /* 展示模态视图 firstController -> secondController
         
         // 全屏幕覆盖显示，如果控制器view有透明，则背景会显示为window，而不是其presentingViewController
         // 也就是说vc1会从window栈中移除，但不会销毁
         // 此时window的结构为
         // window/UITransitionView/UIDropShadowView(firstController已经隐藏)
         //       /UITransitionView/secondController
         case fullScreen = 0

         // 在iPhone上部分覆盖了firstControlle，
         // 在iPad上secondController会居中显示，并且内缩，firstController有蒙版
         // secondController可以滑动向下取消显示
         // 此时window的结构为
         // window/UITransitionView/UIDropShadowView(内缩)/firstController
                  /UITransitionView/UIDropShadowView/UIView/UIView/secondController
         case pageSheet = 1

         // 在iPhone上和pageSheet效果一样
         // 在iPad上secondController的大小可以通过preferredContentSize设置
         // window结构和pageSheet一样
         case formSheet = 2

         // 可以用在 iPad UISplitViewController中，指定单独覆盖屏幕单侧的控制器
         // popover方式展示的控制器，再用该方式 present 出下一视图
         // 在执行 present 操作的控制器的控制器层级中往上查找，如果某个控制器的definesPresentationContext == true
         // 则它来 present，假如没有一个为true，那么则由 window.rootController来 present
         // 执行 present 操作的控制器的view和它的subViews，在 present 完成后都会被从当前视图层级移除
         // definesPresentationContext默认为false，系统提供的一些像UINavigationController的控制器，
         // 其默认值为true
         // 对于以currentContext方式推出的视图，如果它的presentedViewController是一个popover
         // 那么推出该视图的modalTransitionStyle不能是partialCurl，否则会引起崩溃。
         case currentContext = 3

         // 由一种自定义呈现控制器和一个或多个自定义动画对象(UIModalTransitionStyle)来管理
         // 默认情况下全屏幕覆盖显示，firstController不会隐藏
         // 此时window的结构为
         // window/UITransitionView/UIDropShadowView/firstController
         //       /UITransitionView/secondController
         case custom = 4

         // 基本fullScreen一致
         // 只是 present 完成后，不会移除执行 present 操作的控制器的view和它的subViews。
         // 如果presentedViewController.view是有透明度的，底层视图就可以得以显示。
         case overFullScreen = 5

         // 基本和currentContext一致。只是 present 完成后，不会移除执行 present 操作的控制器的view和它的subViews。
         // 如果presentedViewController.view是有透明度的，底层视图就可以得以显示
         case overCurrentContext = 6

         // 内容以带箭头弹出视图显示
         // 需要设置popoverPresentationController?.sourceView，表示为secondController的弹出位置
         // 在iPhone上，要设置popoverPresentationController.delegate，在代理中设置adaptivePresentationStyle(for:)
         //    的返回值为none，才会显示为弹出样式，否则以fullScreen方式展示
         // 在iPad上，需要设置popoverPresentationController?.sourceView属性，表示为secondController的弹出位置
         // 如果在secondController中有输入视图，当键盘弹出时，输入控件会调整位置，避免被键盘遮挡
         // 默认情况下，点击灰色的背景popover会直接消失
         // 通过popoverPresentationController?.passthroughViews可以配置灰色背景的哪些视图区域可以点击
         case popover = 7
         
         @available(iOS 7.0, *)
         // 该枚举值不可以直接赋值给modalPresentationStyle
         // popoverPresentationController会调用它delegate的方法来配置popover的视图，
         // none只能用在adaptivePresentationStyle(for:)代理方法中返回，
         // 告诉popoverPresentationController不要适配presentedViewController，这样在 iPhone
         // 中也可以用popover的样式展示
         case none = -1

         @available(iOS 13.0, *)
         // 默认
         case automatic = -2
         */
        switch presentationStyle {
        case .currentContext, .overCurrentContext:
            vc = UINavigationController.init(rootViewController: TableViewController.init())
            vc.preferredContentSize = .init(width: view.frame.width, height: 400)
        default:
            break
        }
        vc.modalPresentationStyle = presentationStyle
        if presentationStyle == .popover, let popverController = vc.popoverPresentationController {
            // 箭头位置
            popverController.permittedArrowDirections = UIPopoverArrowDirection.any
            // 目标视图
            popverController.sourceView = sender
            // 显示位置
            popverController.sourceRect = sender.bounds
            // 背景颜色
            popverController.backgroundColor = .clear
            // 代理
            popverController.delegate = self
            popverController.canOverlapSourceViewRect = false
            vc.preferredContentSize = .init(width: 200, height: 200)
            
        } else if presentationStyle == .none {
            vc.modalPresentationStyle = .popover
        }
        present(vc, animated: true, completion: nil)
    }
}

extension FirstViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    // 点击背景不消失
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
    // 消失时调用
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        
    }
    
}

/*
 
 
 */
