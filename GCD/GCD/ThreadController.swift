//
//  ThreadController.swift
//  GCD
//
//  Created by miaokii on 2021/4/22.
//  Copyright © 2021 ly. All rights reserved.
//

import UIKit
import Foundation

class ThreadController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var semaphore = DispatchSemaphore.init(value: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tap(_ sender: Any) {
        startNewThread()
        autoNewThread()
        implicitNewThread()
        threadFunc()
        downloadImage()
    }
    
    @IBAction func operation(_ sender: Any) {
        
    }
}


// MARK: - NSThread
extension ThreadController {
    /// 创建并手动启动线程
    func startNewThread() {
        // 创建一个线程，不会自动启动
        let thread = Thread.init(target: self, selector: #selector(threadFunc), object: nil)
        // 命名
        thread.name = "new thread"
        // 启动线程
        thread.start()
        
        // 线程休眠10s
//        Thread.sleep(forTimeInterval: 10)
        // 线程取消
        thread.cancel()
    }
    
    /// 自动启动
    func autoNewThread() {
        // 创建自动启动的线程
        Thread.detachNewThreadSelector(#selector(threadFunc), toTarget: self, with: nil)
    }
    
    /// 隐方创建并启动线程
    func implicitNewThread() {
        performSelector(inBackground: #selector(threadFunc), with: nil)
    }
    
    /// 线程通信
    func threadCommunication() {
        // 在出线程上执行
        performSelector(onMainThread: #selector(threadFunc), with: nil, waitUntilDone: false)
        
        // 在指定线程上操作
        Thread.current.perform(#selector(threadFunc), on: .main, with: nil, waitUntilDone: true)
        
        // 在当前线程上操作
        perform(#selector(threadFunc))
    }
    
    /// 新线程任务
    @objc func threadFunc() {
//        semaphore.wait()
        objc_sync_enter(self)
        let thread = Thread.current
        print("thread name: \(thread.name ?? "")")
        print("is main thread: \(thread.isMainThread)")
        print("--------------")
        objc_sync_exit(self)
//        semaphore.signal()
    }
}

extension ThreadController {
    func downloadImage() {
        let downloadThread = Thread.init {
            let url = URL.init(string: "https://cf.bstatic.com/images/hotel/max1280x900/262/262672564.jpg")!
            guard let data = try? Data.init(contentsOf: url),
                  let image = UIImage.init(data: data) else {
                return
            }
            
            self.performSelector(onMainThread: #selector(self.refresh(image:)), with: image, waitUntilDone: false)
        }
        downloadThread.name = "download Image Thread"
        downloadThread.start()
    }
    
    @objc private func refresh(image: UIImage) {
        imageView.image = image
        
    }
}
