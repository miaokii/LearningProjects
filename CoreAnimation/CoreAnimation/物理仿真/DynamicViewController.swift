//
//  DynamicViewController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/23.
//

import UIKit
import MKSwiftRes

enum DynamicType: Int {
    case gravity = 0
    case snap = 1
    case crash = 2
    case push = 3
    case attachment = 4
    case machAttachment = 5
    
    case springList = 6
    
    var className: UIView.Type {
        switch self {
        case .gravity:
            return GravityBehaviorView.self
        case .snap:
            return SnapBehaviorView.self
        case .crash:
            return CrashBehaviorView.self
        case .push:
            return PushBehaviorView.self
        case .attachment:
            return AttachmentBehaviorView.self
        case .machAttachment:
            return MachObjectAttachmentView.self
            
        case .springList:
            return SpringListView.self
        }
    }
    
    var title: String {
        switch self {
        case .gravity:
            return "重力行为"
        case .snap:
            return "吸附行为"
        case .crash:
            return "碰撞行为"
        case .push:
            return "推动行为"
        case .attachment:
            return "附着行为"
        case .machAttachment:
            return "多对象附着"
        case .springList:
            return "弹性会话列表（iMessage）"
        }
    }
    
    static let all: [Self] = [.gravity, .snap, .crash, .push, .attachment, .machAttachment, springList]
}

class DynamicViewController: MKViewController {
    
    private var dynamicType: DynamicType = .gravity
    
    convenience init(type: DynamicType) {
        self.init(nibName: nil, bundle: nil)
        dynamicType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dynamicViewName = dynamicType.className
        let dynamicView = dynamicViewName.init()
        dynamicView.frame = .init(x: 0, y: 0, width: view.width, height: view.height-MKDefine.navAllHeight)
        view.addSubview(dynamicView)
    }
}
