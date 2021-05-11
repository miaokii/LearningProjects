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
        operationTask()
    }
}

// MARK: - NSOperation
/*
 Operation是对GCD的封装，面向对象，相比于GCD
 增加了代码块、操作依赖关系、优先级、并发数控制等功能
 
 任务（操作）：
 Operation就是要执行的代码块
 抽象类，继承或使用子类
 可以单独执行而不放在OperationQeueue里面，单独调用会在主线程中执行
 子类：InvocationOperation
      BlockOperation
      自定义子类
 
 队列：
 GCD队列调度遵循先进先出（FIFO）原则
 OperationQueue队列调度顺序由任务的优先级决定
 OperationQueue通过最大并发操作数控制并发、串行
 OperationQueue两类队列：主队列和自定义队列
 
 OperationQueue中任务执行顺序根据操作的准备就绪状态和优先级排序执行

 
 
 */
extension ThreadController {
    func operationTask() {
        operationQueueTask()
//        blockOperationTask()
    }
    
    @objc private func blockOperationTask() {
        // 在当前线程执行
        let blockOperation = BlockOperation.init {
            for i in  0..<3 {
                currentThreadSleep(time: 1)
                print("\(i) -- thread: \(Thread.current)")
            }
        }
        
        // 添加其他操作
        // 其他操作可能在其他线程中执行，并行，所有操作完成，整体才算完成
        // 系统控制线程创建与否
        blockOperation.addExecutionBlock {
            currentThreadSleep(time: 1)
            print("execution1 -- thread: \(Thread.current)")
        }
        blockOperation.addExecutionBlock {
            currentThreadSleep(time: 1)
            print("execution2 -- thread: \(Thread.current)")
        }
        blockOperation.addExecutionBlock {
            currentThreadSleep(time: 1)
            print("execution3 -- thread: \(Thread.current)")
        }
        blockOperation.addExecutionBlock {
            currentThreadSleep(time: 1)
            print("execution4 -- thread: \(Thread.current)")
        }
        
        // 开始执行操作
        blockOperation.start()
        // 标记为isCancelled状态
        blockOperation.cancel()
        // 操作是否结束
        print(blockOperation.isFinished)
        // 操作是否在执行
        print(blockOperation.isExecuting)
        // 操作是否是就绪状态
        print(blockOperation.isReady)
        
        // 阻塞当前线程，知道任务结束
        blockOperation.waitUntilFinished()
        // 任务结束的回调
        blockOperation.completionBlock = {
            print("执行结束")
        }
    }
    
    private func operationQueueTask() {
        // 主队列
        let mainQueue = OperationQueue.main
        // 自定义队列
        // 会创建新线程
        let cusQueue = OperationQueue.init()
        cusQueue.name = "cus queue"
        
        let block1 = BlockOperation.init {
            currentThreadSleep(time: 1)
            print("block1 --- \(Thread.current.name ?? "")")
        }
        let block2 = BlockOperation.init {
            currentThreadSleep(time: 1)
            print("block2 --- \(Thread.current.name ?? "")")
        }
        let block3 = BlockOperation.init {
            currentThreadSleep(time: 1)
            print("block3 --- \(Thread.current.name ?? "")")
        }
        let block4 = BlockOperation.init {
            currentThreadSleep(time: 1)
            print("block4 --- \(Thread.current.name ?? "")")
        }
        
        let block5 = BlockOperation.init {
            currentThreadSleep(time: 2)
            print("block5 -- \(Thread.current.name ?? "")")
            // 线程间的通讯
            OperationQueue.main.addOperation {
                self.imageView.backgroundColor = .cyan
            }
        }
        
        // 添加依赖
        block3.addDependency(block1)
        // 移除依赖
        block3.removeDependency(block1)
        
        block1.addDependency(block4)
        // block3执行前的所有依赖操作
        // print(block3.dependencies)
        
        // 优先级不能取代依赖关系
        // 1依赖4，2，3没有依赖，所以2、3、4是准备状态
        // 1不是准备状态
        // 优先级决定的时进入准备状态的任务的执行顺序
        block3.queuePriority = .high
        // 1的优先级设置最高，但是不是准备状态，所以依然后执行
        // 即 优先级不能取代依赖关系
        block1.queuePriority = .veryHigh
        
        // 最大并发数，设置为1就是串行队列
        // 不是控制并发线程数量，耳饰队列中能并发执行的任务数
        // 一个任务并非只能在一个线程中执行
        cusQueue.maxConcurrentOperationCount = 2
        
        cusQueue.addOperation(block1)
        cusQueue.addOperation(block2)
        cusQueue.addOperation(block3)
        cusQueue.addOperation(block4)
        cusQueue.addOperation(block5)
        
        // 取消所有操作
//        cusQueue.cancelAllOperations()
        // 队列是否暂停
//        print(cusQueue.isSuspended)
        // 设置队列暂停和恢复
//        cusQueue.isSuspended = false
        // 同步，阻塞线程，知道所有操作完成
//        cusQueue.waitUntilAllOperationsAreFinished()
        // 添加操作，是否等待添加前的操作完成才执行
        cusQueue.addOperations([BlockOperation.init(block: {
            print("操作完成")
        })], waitUntilFinished: true)
        // 操作数
        print(cusQueue.operationCount)
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
