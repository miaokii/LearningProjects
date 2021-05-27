//
//  CatonListController.swift
//  RunLoop
//
//  Created by miaokii on 2021/5/25.
//

import UIKit

class CatonListController: UITableViewController {
    private var timer: Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "加载图片"
        timer = Timer.scheduledTimer(timeInterval: 1, target: WeakProxy.init(target: self), selector: #selector(timerTrigger), userInfo: nil, repeats: true)
        timer.fireDate = .distantPast
        RunLoop.current.add(timer, forMode: .common)
        
        tableView.tableFooterView = .init()
        tableView.register(TableCell.classForCoder(), forCellReuseIdentifier: "Cell")
    }
    
    deinit {
        timer.invalidate()
    }
    
    @objc private func timerTrigger() {
        print("timer 运行中")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableCell
        cell.setImages()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableCell.height
    }
}

fileprivate class TableCell: UITableViewCell {
    private var imageView1: UIImageView!
    private var imageView2: UIImageView!
    private var imageView3: UIImageView!
    private var imageBundle: Bundle!
    
    private static let width: CGFloat = floor(UIScreen.main.bounds.width-40)/3
    static let height: CGFloat = 20+width
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let bundlePath = Bundle.main.path(forResource: "Images", ofType: "bundle")!
        imageBundle = Bundle.init(path: bundlePath)
        
        imageView1 = UIImageView.init()
        imageView1.contentMode = .scaleAspectFill
        contentView.addSubview(imageView1)
        imageView1.frame = .init(x: 10, y: 10, width: Self.width, height: Self.width)
        
        imageView2 = UIImageView.init()
        imageView2.contentMode = .scaleAspectFill
        contentView.addSubview(imageView2)
        imageView2.frame = .init(x: imageView1.frame.maxX+10, y: imageView1.frame.minY, width: Self.width, height: Self.width)
        
        imageView3 = UIImageView.init()
        imageView3.contentMode = .scaleAspectFill
        contentView.addSubview(imageView3)
        imageView3.frame = .init(x: imageView2.frame.maxX+10, y: imageView1.frame.minY, width: Self.width, height: Self.width)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setImages() {
        
        if let imagePath = imageBundle.path(forResource: "image0", ofType: "jpg") {
            imageView1.image = UIImage.init(contentsOfFile: imagePath)
        }
        
        if let imagePath = imageBundle.path(forResource: "image1", ofType: "jpg") {
            imageView2.image = UIImage.init(contentsOfFile: imagePath)
        }
        
        if let imagePath = imageBundle.path(forResource: "image2", ofType: "jpg") {
            imageView3.image = UIImage.init(contentsOfFile: imagePath)
        }
    }
}
