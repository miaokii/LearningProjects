//
//  ViewController.swift
//  ExceptionDeal
//
//  Created by miaokii on 2021/3/1.
//

import UIKit
import MKSwiftRes

class HomeViewController: MKViewController {
    
    private var tableView: UITableView!
    private var datas = [(String, UIViewController.Type)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "崩溃类型"
        
        datas = [("集合类型越界", CollectionsCrashController.self)]
        
        tableView = UITableView.init(super: view,
                                     delegate: self,
                                     separatorStyle: .singleLine)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        tableView.register(cellType: UITableViewCell.self)
    }
}

extension HomeViewController: MKTableViewCombineDelegate {
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

class ContainerView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let line = CALayer.init()
        line.backgroundColor = UIColor.line_gray.cgColor
        line.frame = .init(x: 20, y: frame.height-1, width: frame.width-20, height: 1)
        layer.addSublayer(line)
    }
}
