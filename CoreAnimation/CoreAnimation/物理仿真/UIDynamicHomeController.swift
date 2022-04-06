//
//  UIDynamicController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/23.
//

import UIKit
import MKSwiftRes

/*
 UIDynamic是UIKit的物理驱动引擎，实现了动力、铰链连接、碰撞、悬挂等效果
 三个重要概念：
    Dynamic Animator：动画者，为动力学元素提供物理相关的能力和动画，同事为这些元素提供上下文，是动力学元素与底层iOS物理引擎之间的中介，将Behavoir对象添加到Animator即可实现动力仿真
    Dynamic Animator Item：动力学元素，是任何遵守了UIDynamic协议的对象，UIView和UICollectionViewLayoutAttributes默认实现协议，如果自定义对象实现了该协议，即可通过Dynamic Animator实现物理仿真
    UIDynamicBehavior：仿真行为，动力学行为的父类，基本动力学行为类有：
            UIGravityBehavior
            UICollisionBehavior
            UIAttachmentBehavior
            UISnapBehavior
            UIPushbehavior
            UIDynamicItemBehavior均继承自UIDynamicBehavior
 
    物理仿真步骤：
        1、创建仿真者UIDynamicAnimator对象用来仿真所有物理行为
        2、创建物理仿真行为（如：UIGravity）模拟物理行为
        3、将物理仿真行为添加到仿真者实现仿真效果
 */

class UIDynamicHomeController: MKViewController {
    
    private var tableView: UITableView!
    private var datas = DynamicType.all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView.init(super: view,
                                     delegate: self,
                                     separatorStyle: .singleLine)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        tableView.register(cellType: UITableViewCell.self)
    }
}

extension UIDynamicHomeController: MKTableViewCombineDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(type: UITableViewCell.self, at: indexPath)
        cell.textLabel?.text = datas[indexPath.row].title
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DynamicViewController.init(type: DynamicType.init(rawValue: indexPath.row)!)
        vc.title = datas[indexPath.row].title
        navigationController?.pushViewController(vc, animated: true)
    }
}
