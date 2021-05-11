//
//  PresentTranstionController.swift
//  ModalView
//
//  Created by miaokii on 2021/2/3.
//

import UIKit
import MKSwiftRes

class PresentTranstionController: MKViewController {

    private var tableView: UITableView!
    private var datas = [(String, UIViewController.Type)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CustomTransition"

        datas = [("淡入淡出不可交互", FadeInOutAViewController.self),
                 ("滑动可交互", SwipeAViewController.self),
                 ("自定义PresentationController", CustomAViewController.self)]
        
        tableView = UITableView.init(super: view,
                                     delegate: self,
                                     separatorStyle: .singleLine)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        tableView.register(cellType: UITableViewCell.self)
    }
}

extension PresentTranstionController: MKTableViewCombineDelegate {
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
//        navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true, completion: nil)
    }
}

