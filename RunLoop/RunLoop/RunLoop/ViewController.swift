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
        mainRunLoopOberver()
    }
    @IBAction func runCustomThreadSelector(_ sender: Any) {
        perform(#selector(newThreadSelector), on: newThread, with: nil, waitUntilDone: true)
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
    
    private func currentRunLoop() {
        let runLoop = RunLoop.current
        let cfRunLoop = CFRunLoopGetCurrent()
        runLoop.getCFRunLoop()
        
        // 运行RunLoop
        // 直接运行，如果没有输入源会自动退出
        runLoop.run()
        // 到指定时间结束运行，在此之前所有的输入源事件正常处理
        runLoop.run(until: Date.init(timeIntervalSinceNow: 1))
        // 运行一次循环，阻止在指定模式下输入直到给定日期
        runLoop.run(mode: .common, before: Date())
        
        // 停止runLoop
        runLoop.run(until: Date.init(timeIntervalSinceNow: 1))
        // 手动停止
        CFRunLoopStop(cfRunLoop)
        
    }
    
    private func mainRunLoopOberver() {
        let runLoop = RunLoop.current
        let cfRunLoop = runLoop.getCFRunLoop()
        let runLoopObserverHandle:(CFRunLoopObserver?, CFRunLoopActivity)->Void = { (cf, ac) in
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
        
        // 卡普奇 Youbi六代
        
        let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.allActivities.rawValue, true, 0, runLoopObserverHandle)
        CFRunLoopAddObserver(cfRunLoop, observer, .defaultMode)
        
//        let timer = Timer.scheduledTimer(timeInterval: 1, target: WeakProxy.init(target: self), selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func fireTimer() {
        print("timer tigger")
    }
}

