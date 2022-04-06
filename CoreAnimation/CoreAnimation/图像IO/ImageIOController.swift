//
//  ImageIOController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/26.
//

import UIKit
import MiaoKiit

class ImageIOController: MKViewController {
    
    private var tableView: UITableView!
    private var datas = [(String, UIViewController.Type)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datas = [("加载和潜伏", ImageLoadController.self),
                 ("缓存", ImageCacgeController.self)]
        
        tableView = UITableView.init(super: view,
                                     delegate: self,
                                     dataSource: self,
                                     separatorStyle: .singleLine)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        tableView.register(cellType: UITableViewCell.self)
    }
}

extension ImageIOController: UITableViewDelegate, UITableViewDataSource {
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
        vc.title = datas[indexPath.row].0
        navigationController?.pushViewController(vc, animated: true)
    }
}
