//
//  TransitionStyleController.swift
//  ModalView
//
//  Created by miaokii on 2021/1/28.
//

import UIKit

class TransitionStyleController: MKViewController {

    private var tableView: UITableView!
    private var datas = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TransitionStyle"
        
        datas = ["coverVertical", "flipHorizontal", "crossDissolve", "partialCurl"]
        
        tableView = UITableView.init(super: view,
                                     delegate: self,
                                     separatorStyle: .singleLine)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.register(cellType: UITableViewCell.self)
    }
}

extension TransitionStyleController: MKTableViewCombineDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(type: UITableViewCell.self, at: indexPath)
        cell.textLabel?.text = datas[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transtyle = UIModalTransitionStyle.init(rawValue: indexPath.row)!
        let vc = TransitionController.init()
        vc.modalTransitionStyle = transtyle
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}


fileprivate class TransitionController: MKViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* UIModalTransitionStyle
         
         // 当呈现视图时从下往上滑入，呈现结束从上往下滑出，默认
         case coverVertical = 0
         // 当呈现视图时会从右向左启动水平3D翻转，从而显示新视图，就好像它位于前一个视图的背面一样
         // 取消时，翻转从左往右，返回到原始视图
         case flipHorizontal = 1
         // 呈现视图控制器时，当前视图淡出，而新视图同时淡入
         // 取消时，将使用类似类型的淡入淡出效果返回到原始视图。
         case crossDissolve = 2
         // 呈现视图控制器时，从右下角卷起，想翻页一样的效果
         // 取消显示时，反之
         // 当使用该模式，控制器本身无法呈现其他试图控制器
         // 当试用改模式，UIModalPresentationStyle需设置为fullScreen模式，否则崩溃
         case partialCurl = 3
         */
        
        view.backgroundColor = UIColor.random
        
        let cloase = UIButton.init(type: .close)
        cloase.setClosure { [unowned self] (_) in
            self.popOrDismiss()
        }
        
        view.addSubview(cloase)
        cloase.snp.makeConstraints { (make) in
            make.top.equalTo(MKDefine.statusBarHeight + 20)
            make.centerX.equalToSuperview()
        }
    }
}
