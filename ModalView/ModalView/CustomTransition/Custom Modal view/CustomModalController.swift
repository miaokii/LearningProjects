//
//  CustomModalController.swift
//  ModalView
//
//  Created by miaokii on 2021/1/28.
//

import UIKit
import MKSwiftRes

class CustomModalController: UIViewController {

    fileprivate enum CusTransitionStyle {
        case fadeInOut
    }
    
    private var tableView: UITableView!
    private var datas = [(String, MKPopViewController.PopStyle, MKPopViewController.Type)]()
    
    private var curTransStyle: CusTransitionStyle = .fadeInOut
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ModalTransition"
        
        datas = [("底部弹出", .bottom, PopController.self),
                 ("上方弹出", .top, PopController.self),
                 ("中部弹出", .center, PopController.self),
                 ("左侧滑出", .left, DiDiLeftMenuView.self),
                 ("右侧滑出", .right, PopController.self),
                 ("科室选择picker", .bottom, PartPickerController.self),
                 ("日期选择picker", .bottom, DatePickerController.self),
                 ("警告信息", .top, PopMessageView.self),
                 ("自定义", .custom, CustomPopController.self)]
        
        tableView = UITableView.init(super: view,
                                     delegate: self,
                                     separatorStyle: .singleLine)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        tableView.register(cellType: UITableViewCell.self)
    }
}

extension CustomModalController: MKTableViewCombineDelegate {
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
        let vcClass = datas[indexPath.row].2
        if vcClass.classForCoder() == PopMessageView.classForCoder() {
            PopMessageView.flash(waring: "请输入验证码")
        } else {
            let vc = vcClass.init()
            if vc is PopController {
                vc.popStyle = datas[indexPath.row].1
            }
            vc.show()
        }
    }
}
