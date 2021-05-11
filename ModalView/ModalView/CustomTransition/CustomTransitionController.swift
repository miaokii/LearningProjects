//
//  CustomTransitionController.swift
//  ModalView
//
//  Created by miaokii on 2021/1/28.
//

import Foundation
import MKSwiftRes

class CustomTransitionController: MKViewController {
    /*
     controller切换有四种场景
     1、UITabBarController
     2、UINavigationController
     3、模态视图present(, animated:, completion:)
     4、addchildviewcontroller
     */
    private var tableView: UITableView!
    private var datas = [(String, UIViewController.Type)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CustomTransition"

        datas = [("UITabBarController", TransitionTabbarController.self),
                 ("Present Transtion Controller", PresentTranstionController.self),
                 ("自定义模态视图", CustomModalController.self)]
        
        tableView = UITableView.init(super: view,
                                     delegate: self,
                                     separatorStyle: .singleLine)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        tableView.register(cellType: UITableViewCell.self)
    }
}

extension CustomTransitionController: MKTableViewCombineDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(type: UITableViewCell.self, at: indexPath)
        cell.textLabel?.text = datas[indexPath.row].0
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcClass = datas[indexPath.row].1
        let vc = vcClass.init()
//        if vc is UITabBarController {
//            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: true, completion: nil)
//        } else {
            navigationController?.pushViewController(vc, animated: true)
//        }
    }
}

