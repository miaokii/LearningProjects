//
//  ViewController.swift
//  RunLoop
//
//  Created by miaokii on 2021/5/25.
//

import UIKit

class ViewController: UIViewController {

    private var newThread: Thread!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchNewThread()
    }
    @IBAction func runCustomThreadSelector(_ sender: Any) {
        perform(#selector(newThreadSelector), on: newThread, with: nil, waitUntilDone: true)
        perform(<#T##aSelector: Selector##Selector#>, with: <#T##Any?#>, afterDelay: <#T##TimeInterval#>)
    }
    
    /// 创建新线程，并执行任务
    /// 正常情况下，线程执行完任务后，后自动退出
    /// 开启线程的RunLoop可以保持线程的活性，处理新事件
    func launchNewThread() {
        newThread = Thread.init(target: self, selector: #selector(threadSelector), object: nil)
        newThread.name = "custom thread"
        newThread.start()
    }
    
    // 开启新线程的RunLoop
    @objc private func threadSelector() {
        print("task start")
        RunLoop.current.add(Port.init(), forMode: .default)
        RunLoop.current.run()
        print("task end")
    }
    
    // 在新线程上执行另一个任务
    @objc private func newThreadSelector() {
        print("new task start")
        print(Thread.current)
        print("new task end")
    }
}

