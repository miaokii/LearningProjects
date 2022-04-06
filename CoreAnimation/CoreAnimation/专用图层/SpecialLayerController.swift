//
//  SpecialLayerController.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/18.
//

import UIKit
import MKSwiftRes

class SpecialLayerController: MKViewController {
    
    private var tableView: UITableView!
    private var datas = [(String, UIViewController.Type)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datas = [("CAShapeLayer", ShapLayerController.self),
                 ("CATextLayer", TextLayerController.self),
                 ("CATransformLayer", TransformLayerController.self),
                 ("CAGradientLayer", GradientLayerController.self),
                 ("CAReplicatorLayer", ReplicatorLayerController.self),
                 ("CAEmitterLayer", EmitterLayerController.self)]
        
        tableView = UITableView.init(super: view,
                                     delegate: self,
                                     separatorStyle: .singleLine)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        tableView.register(cellType: UITableViewCell.self)
    }
}

extension SpecialLayerController: MKTableViewCombineDelegate {
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
