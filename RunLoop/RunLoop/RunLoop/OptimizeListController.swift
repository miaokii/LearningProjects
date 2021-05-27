//
//  OptimizeListController.swift
//  RunLoop
//
//  Created by miaokii on 2021/5/25.
//

import UIKit

typealias RunloopBlock = ()->Bool
fileprivate let CellId = "Cellid"
class OptimizeListController: UITableViewController {
    
    // 使用runloop优化
    private var useRunLoop = true
    // cell高度
    private let cellHeight = TableCell.height
    // runloop空闲时执行的代码
    private var runloopBlockArr = [RunloopBlock]()
    // runloopBlockArr最大执行任务数
    private var maxQueueTaskCount: Int {
        return Int(UIScreen.main.bounds.height/cellHeight)+2
    }
    
    fileprivate let runloopBeforeWaitingCallBack = { (ob: CFRunLoopObserver?, ac: CFRunLoopActivity) in
        print("runloop循环完毕")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "加载图片"
        addWaitingRunloopObserver()
        
        tableView.tableFooterView = .init()
        tableView.register(TableCell.classForCoder(), forCellReuseIdentifier: CellId)
        
        let switchView = UISwitch.init()
        switchView.isOn = useRunLoop
        switchView.addTarget(self, action: #selector(switchRunloopOptimize), for: .valueChanged)
        navigationItem.titleView = switchView
    }
    
    @objc private func switchRunloopOptimize() {
        useRunLoop.toggle()
        print("使用runloop优化: \(useRunLoop)")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if useRunLoop {
            return loadCellWithRunloop(indexPath: indexPath)
        } else {
            return loadCell(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

enum RunLoopError: Error {
    case canNotCreate
}

extension OptimizeListController {
    // 添加runloop循环结束的监听
    func addWaitingRunloopObserver() {
        // 获取当前的runloop
        let runloop = CFRunLoopGetCurrent()
        // 需要监听的runloop状态
        let activities = CFRunLoopActivity.beforeWaiting.rawValue
        // 创建观察者
        let observer = CFRunLoopObserverCreateWithHandler(nil, activities, true, Int.max-999, { [weak self] (ob, ac) in
            guard let this = self else { return }
            guard !this.runloopBlockArr.isEmpty else { return }
            // 是否退出任务组
            var quit = false
            while !quit, this.runloopBlockArr.count > 0 {
                // 执行任务
                guard let block = self?.runloopBlockArr.first else {
                    return
                }
                // 是否退出任务
                quit = block()
                // 移除已经完成的任务
                this.runloopBlockArr.removeFirst()
            }
        })
        // 注册runloop观察者
        CFRunLoopAddObserver(runloop, observer, .defaultMode)
    }
    
    /// 添加代码块到数组，在 runloop beforewaiting时执行
    func addRunloopBlock(block: @escaping RunloopBlock) {
        runloopBlockArr.append(block)
        // 快速滑动时，没来得及显示cell不会渲染，只渲染屏幕中的cell
        if runloopBlockArr.count > maxQueueTaskCount {
            runloopBlockArr.removeFirst()
        }
    }
    
    func loadCellWithRunloop(indexPath: IndexPath) -> UITableViewCell  {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath) as? TableCell else {
            return UITableViewCell()
        }
        addRunloopBlock {
            cell.setImages()
            return false
        }
        return cell
    }
    
    func loadCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath) as? TableCell else {
            return UITableViewCell()
        }
        cell.setImages()
        return cell
    }
}

// MARK: - 观察所有runloop运行阶段
extension UIViewController {
    func addRunloopObserver() {
        do {
            let block = { (ob: CFRunLoopObserver?, ac: CFRunLoopActivity) in
                if ac == .entry {
                    print("进入 runloop")
                }
                else if ac == .beforeTimers {
                    print("即将处理timer事件")
                }
                else if ac == .beforeWaiting {
                    print("runloop即将休眠")
                }
                else if ac == .afterWaiting {
                    print("runloop被唤醒")
                }
                else if ac == .exit {
                    print("退出runloop")
                }
            }
            
            let ob = try createRunLoopObservable(block: block)
            CFRunLoopAddObserver(CFRunLoopGetCurrent(), ob, .defaultMode)
        } catch RunLoopError.canNotCreate {
            print("runloop 观察者创建失败")
        }
        catch {}
    }
    
    private func createRunLoopObservable(block: @escaping(CFRunLoopObserver?, CFRunLoopActivity) -> Void) throws -> CFRunLoopObserver {
        /*
         allocator: 分配内存给新的对象，默认情况下nil或者default
         activities: 运行阶段标志，当运行到此阶段，observer就会被调用
         repeats：是否循环
         order：优先级，0
         block：回调，参数1：正在运行的runloop observer
                    参数2：runloop当前运行的阶段
         */
        let ob = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.allActivities.rawValue, true, 0, block)
        guard let observer = ob else {
            throw RunLoopError.canNotCreate
        }
        return observer
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
