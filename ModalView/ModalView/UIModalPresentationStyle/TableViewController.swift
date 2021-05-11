//
//  TableViewController.swift
//  ModalView
//
//  Created by miaokii on 2021/1/27.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.backgroundColor = .white
        title = "Root"
        tableView.tableFooterView = .init()
        
        let leftItem = UIButton.init(type: .close)
        leftItem.setClosure { [unowned self] (_) in
            self.dismiss()
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftItem)
    }
    
    @objc private func dismiss() {
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID") ?? UITableViewCell.init(style: .default, reuseIdentifier: "ID")
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
