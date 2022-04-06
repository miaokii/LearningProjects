//
//  HomeViewController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/18.
//

import UIKit
import MiaoKiit

class HomeViewController: MKViewController {
    
    private var tableView: UITableView!
    private var datas = [(String, UIViewController.Type)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        datas = [("Layer部分属性", LayerPropertyController.self),
                 ("阴影和蒙版效果", ShadowViewController.self),
                 ("模拟时钟", ClockViewController.self),
                 ("光影立方体", CubeViewController.self),
                 ("专用图层", SpecialLayerController.self),
                 ("隐式动画", ImplicitAnimationController.self),
                 ("显式动画", ExplicitAnimationController.self),
                 ("图层时间", LayerTimeController.self),
                 ("缓冲", AnimationBufferController.self),
                 ("定时器动画", TimerAnimationController.self),
                 ("物理模拟", UIDynamicHomeController.self),
                 ("高效绘图", DrawingViewController.self),
                 ("图像IO", ImageIOController.self)]
        
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
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
