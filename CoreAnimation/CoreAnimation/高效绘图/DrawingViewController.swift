//
//  DrawingViewController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/25.
//

import UIKit
import MiaoKiit

/*
    CALayer：只消一些耗于自己相关的内存，如设置contents属性的图片，不需要增加额外的存储大小，如果多个图层contents共用一张图片，并不会复制内存块，而是复制内存块
    如果实现了CALyerDelegate的drawLayer:inContext方法或者UIView的drawRect方法（前者的包装方法），图层就会创建一个绘制上下文，所需的内存大小为：图层宽*图层高*4字节，宽高为单位为像素，所以图层每次重绘都要抹掉内存然后重新分配，所以，除非必要，应该避免重绘视图。
 
 */

class DrawingViewController: MKViewController {
    
    private var tableView: UITableView!
    private var datas = [(String, UIViewController.Type)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datas = [("矢量图形", VectorDrawController.self),
                 ("脏矩形", BrushDrawController.self)]
        
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

extension DrawingViewController: UITableViewDelegate, UITableViewDataSource {
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
