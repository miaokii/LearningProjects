//
//  ImplicitAnimationController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/19.
//

import UIKit
import MKSwiftRes

/*
 事务
    事务是CoreAnimation用来包含一系列属性动画集合的机制
    任何用指定事务去改变可以做动画的图层属性都不会立刻发生变化，而是事务提交时开始用一个动画过渡到新的值
 
    事务CATransaction不能用init方法创建，可以用begin和commit分别入栈和出栈
    通过setAnimationDuration方法设置当前事务的动画时间
    事务默认的动画时间为0.25s
    通过setCompletionBlock闭包设置事务执行结束的代码块
    通过setDisableActions对所有属性打开或者关闭隐式动画
 
    Core Animation在每个run loop周期中自动开始一次新的事务即使不显式的用begin开始一次事务，任何在一次run loop循环中属性的改变都会被集中起来，然后做一次0.25秒的动画
 
 RunLoop
    run loop是iOS负责收集用户输入，处理定时器或者网络事件并且重新绘制屏幕的机制
 
    直接对UIView关联的图层做动画而不是一个单独的图层不会发生隐式动画，
    UIView会屏蔽其关联图层的动画的效果，如果要对关联图层做动画效果，可以使用UIView
    的动画函数，或者继承UIView，重写actionForLayer:forKey:方法，或者直接创建一个
    显示动画
 
 图层行为：
    将改变属性时CALayer自动应用动画的称作行为，行为是被CoreAnimation隐式调用的显式
    动画对象
 
 隐式动画的实现：
    当CALayer属性被修改时，会调用actionForKey方法，传递属性名称，并执行以下操作：
        - 图层首先检测它是否有委托，并且是否实现CALayerDelegate协议指定的
          actionForLayer:forKey方法。如果有，直接调用并返回结果。
        - 如果没有委托，或者委托没有实现actionForLayer:forKey方法，
          图层接着检查包含属性名称对应行为映射的actions字典。
        - 如果actions字典没有包含对应的属性，那么图层接着在它的style字典接着搜索属性名。
        - 最后，如果在style里面也找不到对应的行为，那么图层将会直接调用定义了每个属性
          的标准行为的-defaultActionForKey:方法
    当一轮搜索结束，actionForKey要么返回空（不会有动画发生），要么返回CAAction协议的对象
    左后CALayer拿到这个结果对前后的属性值做动画
 
    UIView禁用隐式动画：UIView是关联图层的代理，并提供actionForLayer:forKey的实现
    如果改变Layer的属性不在UIView的动画块中，UIView对该图层行为返回nil，如果在动画块中
    返回非空
 
    对于单独存在的图层，可以通过实现图层的actionForLayer:forKey:代理方法，或者提供一个
    acions字典来控制隐式动画
 
 */
class ImplicitAnimationController: MKViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customCATransitionTest()
    }
    
    // 改变layer的背景颜色
    // CoreAnimation会隐式的添加动画
    private func implicitAnimation() {
        let anView = UIView.init(super: view)
        anView.frame = .init(x: 40, y: 20, width: view.width-80, height: 140)
        let alayer = CALayer.init()
        anView.layer.addSublayer(alayer)
        alayer.backgroundColor = UIColor.random.cgColor
        alayer.frame = anView.bounds
        
        let changeLayerColor = UIButton.themeBorderBtn(super: anView, title: "change color")
        changeLayerColor.setClosure { (_) in
            // 开始事务
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            // 直接对图层做属性修改，会有动画
            alayer.backgroundColor = UIColor.random.cgColor
            // 直接对UIView关联的图层做属性修改，不会有动画
            anView.backgroundColor = UIColor.random
            CATransaction.setCompletionBlock {
                print("颜色已改变")
            }
            CATransaction.commit()
        }
        changeLayerColor.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    /// UIView的actionForLayer:forKey:实现
    private func layerActionForKeyTest() {
        // layer属性在动画块外发生改变，view代理的actionForLayer:forKey返回nil
        // 以禁用隐式动画实现
        print("OutSide：\(String(describing: view.action(for: view.layer, forKey: "backgroundColor")))")
        // 执行动画块
        UIView.beginAnimations(nil, context: nil)
        // 在动画块范围之内，返回动画类型CABasicAnimation
        print("InSide：\(String(describing: view.action(for: view.layer, forKey: "backgroundColor")))")
        UIView.commitAnimations()
    }
    
    // 实现自定义行为
    // 推进过渡
    private func customCATransitionTest() {
        let anView = UIView.init(super: view)
        anView.frame = .init(x: 40, y: 20, width: view.width-80, height: 140)
        
        let alayer = CALayer.init()
        anView.layer.addSublayer(alayer)
        alayer.backgroundColor = UIColor.random.cgColor
        alayer.frame = anView.bounds
        
        // actions
        let transition = CATransition.init()
        transition.type = .push
        transition.subtype = .fromLeft
        alayer.actions = ["backgroundColor": transition]
        
        let changeLayerColor = UIButton.themeBorderBtn(super: view, title: "change color")
        changeLayerColor.setClosure { (_) in
            alayer.backgroundColor = UIColor.random.cgColor
        }
        changeLayerColor.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(anView.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
    }
}
