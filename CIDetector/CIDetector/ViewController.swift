//
//  ViewController.swift
//  PreLoadList
//
//  Created by yoctech on 2021/10/9.
//

import UIKit
import SnapKit
import MiaoKiit

class ViewController: UIViewController {
    
    private var tableView: UITableView!
    private var datas = [(String, UIViewController.Type)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "CIDetector"
        view.backgroundColor = .white
        
        datas = [("检测人脸",FaceDetecotrController.self),
                 ("识别文本",TextDetectorController.self),
                 ("检测矩形",FaceDetecotrController.self),
                 ("识别二维码",FaceDetecotrController.self)]
        
        tableView = UITableView.init(super: self.view,
                                     delegate: self,
                                     dataSource: self,
                                     backgroundColor: .white,
                                     separatorStyle: .singleLine)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        tableView.register(cellType: UITableViewCell.self)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(type: UITableViewCell.self, at: indexPath)
        cell.textLabel?.text = datas[indexPath.item].0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = datas[indexPath.row].1.init()
        navigationController?.pushViewController(vc, animated: true)
    }
}

