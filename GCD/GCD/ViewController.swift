//
//  ViewController.swift
//  GCD
//
//  Created by iMac on 2018/10/18.
//  Copyright © 2018年 ly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// 票数
    var tickets = 30
    var ticketSempaphore: DispatchSemaphore!
    
    var dataSource: DispatchSourceUserDataAdd!
    var timerSource: DispatchSourceTimer!
    var progress: UInt = 0
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
    
    @IBAction func taped(_ sender: Any) {
        queueWorkItem()
    }
}

// MARK: - DispatchWorkItem
extension ViewController {
    func queueWorkItem() {
        let workItem = DispatchWorkItem.init {
            print("task A")
        }
        workItem.notify(queue: .main) {
            print("task A end")
        }
        workItem.perform()
    }
}

// MARK: - dispatch_source
extension ViewController {
    // DispatchSource用于监听和处理底层的系统事件，例如文件操作，timer和
    /*
     DispatchSourceFileSystemObject 监听文件系统事件
     DispatchSourceMachReceive      监听Mach端口中消息接受事件
     DispatchSourceMachSend         监听Mach端口中消息发送事件
     DispatchSourceMemoryPressure   监听内存压力状况时间
     DispatchSourceProcess          监听其他进程事件
     DispatchSourceRead             监听文件读取事件
     DispatchSourceSignal           监听当前进程signal信号事件
     DispatchSourceTimer            计时器
     DispatchSourceUserDataAdd      监听合并and操作事件
     DispatchSourceUserDataOr       监听合并or操作事件
     DispatchSourceWrite            监听文件写事件
     */
    
    // 监听邮件app
    func sourceTimer() {
        initDataSource()
        if timerSource != nil, !timerSource.isCancelled {
            timerSource.cancel()
            timerSource = nil
            return
        }
        timerSource = DispatchSource.makeTimerSource(flags: .strict, queue: .global())
        /// 首次执行时间、timer间隔、精度
        timerSource.schedule(deadline: .now(), repeating: 1, leeway: .seconds(0))
        timerSource.setEventHandler { [weak self] in
            guard let this = self else {
                return
            }
            this.progress += 1
            if this.progress >= 10 {
                this.timerSource.cancel()
                this.timerSource = nil
            }
            this.dataSource.add(data: this.progress)
        }
        timerSource.resume()
    }
    
    func initDataSource() {
        guard dataSource == nil else {
            return
        }
        dataSource = DispatchSource.makeUserDataAddSource(queue: getGlobalQueue())
        dataSource.setEventHandler { [weak self] in
            guard let this = self else { return }
            var progress = this.dataSource.data
            if progress >= 10 {
                progress = 10
                this.dataSource.cancel()
                this.dataSource = nil
            }
            print("progress: \(progress)")
        }
        dataSource.resume()
    }
}

// MARK: - 队列与任务组合
extension ViewController {
    
    func sysQueue()  {
        let queue = DispatchQueue.init(label: "gcd.serial.queue", qos: .default)
        let concurrentQueue = DispatchQueue.init(label: "gcd.concurrent.queue", qos: .default, attributes: .concurrent)
        queue.sync {
            print("sync task")
        }
        queue.async {
            print("async task")
        }
        
    }
    
    /// 在其他线程中 创建串行队列执行同步任务
    func customThreadRunSerialSync() {
        let thread = Thread.init(target: self, selector: #selector(mainQueueMainThreadSync), object: nil)
        thread.name = "serialThread"
        thread.start()
    }
    
    /// 串行队列执行同步任务
    /// 不会创建新线程，如果在主线程中执行，会阻塞主线程
    /// 任务按照添加顺序执行
    /// 同步任务不具备开启新线程的能力
    /// 在主队列中执行，所以当前线程是主线程
    @objc func serialSync() {
        let serialQueue = DispatchQueue.init(label: "gcd.serial.queue")
        var currentThread: Thread { return Thread.current }
        
        print("current thread: \(currentThread)")
        print("begin task")
        serialQueue.sync {
            currentThreadSleep(time: 1)
            print("task 1, current thread: \(currentThread)")
        }
        serialQueue.sync {
            currentThreadSleep(time: 1)
            print("task 2, current thread: \(currentThread)")
        }
        serialQueue.sync {
            currentThreadSleep(time: 1)
            print("task 3, current thread: \(currentThread)")
        }
        print("end task")
    }
    
    /// 串行队列执行异步任务
    /// 异步任务可以创建新线程
    /// 串行队列只能开启一个线程
    /// 串行队列一次只能执行一个任务
    /// 任务执行需要等前一个任务执行完毕再执行
    /// 任务按照添加顺序执行
    @objc func serialAsync() {
        let serialQueue = DispatchQueue.init(label: "gcd.serial.queue")
        var currentThread: Thread { return Thread.current }
        print("current thread: \(currentThread)")
        print("begin task")
        serialQueue.async {
            currentThreadSleep(time: 1)
            print("task 1, current thread: \(currentThread)")
        }
        serialQueue.async {
            currentThreadSleep(time: 1)
            print("task 2, current thread: \(currentThread)")
        }
        serialQueue.async {
            currentThreadSleep(time: 1)
            print("task 3, current thread: \(currentThread)")
        }
        print("end task")
    }
    
    /// 并行队列执行同步任务
    /// 同步任务不能开启新线程，只会在当前线程中执行
    /// 并行队列可以开启多个线程，但是本身不能创建线程
    /// 当前只有主线程，所以在主线程中执行任务
    /// 同步任务按照添加任务顺序执行
    func concurrentSync() {
        /// 并行队列
        let concurrentQueue = DispatchQueue.init(label: "gcd.concurrent.queue", attributes: .concurrent)
        var currentThread: Thread { return getCurrentThread() }
        
        print("current thread: \(currentThread)")
        print("begin task")
        
        concurrentQueue.sync {
            currentThreadSleep(time: 1)
            print("task 1, current thread: \(currentThread)")
        }
        concurrentQueue.sync {
            currentThreadSleep(time: 1)
            print("task 2, current thread: \(currentThread)")
        }
        concurrentQueue.sync {
            currentThreadSleep(time: 1)
            print("task 3, current thread: \(currentThread)")
        }
        print("end task")
    }
    
    /// 并行队列执行异步任务
    /// 异步任务可以创建新线程，并行队列可以开启多线程
    /// 多个任务可以同时执行
    
    func concurrentAsync() {
        /// 并行队列
        let concurrentQueue = DispatchQueue.init(label: "gcd.concurrent.queue", attributes: .concurrent)
        var currentThread: Thread { return getCurrentThread() }
        
        print("current thread: \(currentThread)")
        print("begin task")
        
        concurrentQueue.async {
            currentThreadSleep(time: 1)
            print("task 1, current thread: \(currentThread)")
        }
        concurrentQueue.async {
            currentThreadSleep(time: 1)
            print("task 2, current thread: \(currentThread)")
        }
        concurrentQueue.async {
            currentThreadSleep(time: 1)
            print("task 3, current thread: \(currentThread)")
        }
        print("end task")
    }
    
    /// 主队列 同步执行
    /// 主队列中只有main线程，同步执行任务会发生相互等待
    /// mainQueueMainThreadSync函数实在主线程中执行的
    /// 函数体内部添加了同步任务
    /// 同步任务需要等上一个执行完下一个才开始执行
    /// 所以新添加的任务要等待mainQueueMainThreadSync执行完才能执行
    /// 而mainQueueMainThreadSync要等待新添加的任务执行完才结束
    /// 所以会相互等待完成，就发生卡死
    @objc func mainQueueMainThreadSync() {
        var thread: Thread {
            return getCurrentThread()
        }
        let mainQueue = getMainQueue()
        
        print("current thread: \(thread)")
        print("begin task")
        
        mainQueue.sync {
            currentThreadSleep(time: 1)
            print("current thread: \(thread)")
            print("task 1")
        }
        mainQueue.sync {
            currentThreadSleep(time: 1)
            print("current thread: \(thread)")
            print("task 2")
        }
        print("end task")
    }
    
    /// 主队列中非主线程同步执行任务
    func mainQueueOtherThreadSync() {
        // 创建新线程，执行方法是customThreadFunc
        let newThread = Thread.init(target: self, selector: #selector(customThreadFunc), object: nil)
        // 线程开始执行
        newThread.start()
    }
    
    /// customThreadFunc函数是被添加到newThread里面
    /// customThreadFunc里面的任务被添加到主队列，所以会在出线程中执行
    /// 在加入前主线程没有任务执行，所以会按照添加顺序依次执行
    /// 不会发生相互等待任务结束
    @objc private func customThreadFunc() {
        let mainQueue = getMainQueue()
        var thread: Thread {
            return getCurrentThread()
        }
        print("current thread: \(thread)")
        print("begin task")
        
        mainQueue.sync {
            currentThreadSleep(time: 1)
            print("current thread: \(thread)")
            print("task 1")
        }
        mainQueue.sync {
            currentThreadSleep(time: 1)
            print("current thread: \(thread)")
            print("task 2")
        }
        print("end task")
    }
    
    /// 主队列主线程异步执行任务
    /// 主队列是串行队列，只有一个主线程
    /// 异步任务并不会创建新线程，所有任务都在主线程中执行
    /// 异步任务不会等待mainQueueMainThreadAsync执行完成
    /// 在串行队列中，任务是按照添加顺序执行的
    func mainQueueMainThreadAsync() {
        let mainQueue = DispatchQueue.main
        var currentThread: Thread { return Thread.current }
          print("current thread: \(currentThread)")
          print("begin task")
          mainQueue.async {
                currentThreadSleep(time: 1)
                print("task A, current thread: \(currentThread)")
          }
          mainQueue.async {
                currentThreadSleep(time: 1)
                print("task B, current thread: \(currentThread)")
          }
          print("end task")
    }
    
    /// 栅栏函数
    /// OC dispatch_barrier_async
    /// 栅栏函数将等待前面的任务完成后，执行自己的任务
    /// 再执行随后添加的任务
    /// 栅栏会阻塞当前队列任务的运行，直到他本身的任务执行完成，才继续后面的任务
    func barrierAsync() {
        // 并发队列
        let concurrentQueue = createConcurrentQueue(label: "ConcurrentQueue")
        // 全局队列，栅栏函数对全局队列不起作用
//        let concurrentQueue = getGlobalQueue()
        concurrentQueue.async {
            currentThreadSleep(time: 1)
            print("thread: \(getCurrentThread())")
            print("task 1")
        }
        concurrentQueue.async {
            currentThreadSleep(time: 1)
            print("thread: \(getCurrentThread())")
            print("task 2")
        }
        concurrentQueue.async {
            currentThreadSleep(time: 1)
            print("thread: \(getCurrentThread())")
            print("task 3")
        }
        concurrentQueue.async(group: nil, qos: .default, flags: .barrier) {
            print("thread: \(getCurrentThread())")
            print("task 1-3 执行结束")
        }
        concurrentQueue.async {
            currentThreadSleep(time: 1)
            print("thread: \(getCurrentThread())")
            print("task 4")
        }
        concurrentQueue.async {
            currentThreadSleep(time: 1)
            print("thread: \(getCurrentThread())")
            print("task 5")
        }
        concurrentQueue.async {
            currentThreadSleep(time: 1)
            print("thread: \(getCurrentThread())")
            print("task 6")
        }
    }
    
    /// 延迟执行
    /// 延迟时间并不精确
    /// 延迟任务不是从当前时刻延迟指定时长开始执行任务
    /// 而是在指定时长后将任务添加到主队列
    /// 延迟市场越长越精确
    func asyncAfter() {
        print("thread: \(getCurrentThread())")
        print("begin task")
        
        getMainQueue().asyncAfter(deadline: .now() + 2) {
            print("task run")
        }
        print("end task")
    }
    
    /// dispatch_once_t在swift中废弃
    /// 可以使用懒加载的全局变量来代替
    func callOnce() {
        
    }
    
    /// 快速迭代
    /// oc中调用 dispatch_apply
    /// 按照指定次数追加异步任务到队列里面
    /// 等所有的任务执行完毕，dispatch_apply才执行完成
    func dispatchApply() {
        print("task start")
        DispatchQueue.concurrentPerform(iterations: 10) { (i) in
            currentThreadSleep(time: 1)
            print("task \(i), thread: \(getCurrentThread())")
        }
        // 最后执行，因为要等待迭代任务执行完
        print("task end")
    }
    
    /// 任务组
    /// enter添加任务到任务组
    /// leave移除任务
    /// notify当任务组中没有任务时执行
    func dispatchGroup() {
        let group = DispatchGroup()
        /// 同步等待先前提交的工作完成，如果在指定的超时时间之前未完成工作，则返回。
//        let result = group.wait(timeout: .now()+1)
        let concurrentQueue = createConcurrentQueue(label: "queue")
        
        print("group start")
        
        group.enter()
        concurrentQueue.async {
            currentThreadSleep(time: 1)
            print("thread: \(getCurrentThread())")
            print("task 1")
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async {
            currentThreadSleep(time: 1)
            print("thread: \(getCurrentThread())")
            print("task 2")
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async {
            currentThreadSleep(time: 1)
            print("thread: \(getCurrentThread())")
            print("task 3")
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async {
            currentThreadSleep(time: 1)
            print("thread: \(getCurrentThread())")
            print("task 4")
            group.leave()
        }
        
        
        group.notify(queue: .main) {
            print("group end")
        }
    }
    
    /// GCD信号量
    /// 有计数的信号
    /// 信号量可以控制线程执行还是阻塞
    /// 当计数小于0，阻塞线程、等待
    /// 计数大于等于0，正常执行
    /// wait()，信号量计数-1
    /// signle()，信号量计数+1
    ///
    /// 线程同步
    /// 异步执行任务转换为同步执行任务
    func dispatchSemaphore() {
        /// 创建一个信号量，计数0
        let semaphore = DispatchSemaphore.init(value: 0)
        var number = 0
        let queue = createConcurrentQueue(label: "semaphore queue")
        print("task start")
        // 异步任务
        queue.async {
            currentThreadSleep(time: 2)
            print("thread: \(getCurrentThread())")
            print("teak 1")
            
            number = 100
            // 信号+1，>= 0时，继续执行
            semaphore.signal()
        }
        
        // 信号-1，小于0，等待
        semaphore.wait()
        // 任务体内更改了number
        print("number: \(number)")
        print("task end")
    }
}

// MARK: - 售票模拟
extension ViewController {
    /// 售票
    func sellTicket() {
        tickets = 30
        ticketSempaphore = DispatchSemaphore.init(value: 1)
        
        let aQueue = createSerialQueue(label: "a queue")
        let bQueue = createSerialQueue(label: "b queue")
        
        print("start sell")
        aQueue.async {
            self.safeSellTicket()
//            self.unsafeSellTicket()
        }
        
        bQueue.async {
            self.safeSellTicket()
//            self.unsafeSellTicket()
        }
    }
    
    /// 售票
    /// 不安全，aQueue和bQueue会同时读取余票
    func unsafeSellTicket() {
        while true {
            // 有余票
            if (tickets > 0) {
                tickets -= 1
                let thread = String.init(format: "%p", getCurrentThread())
                print("余票\(tickets), thread: \(thread)")
            } else {
                print("end sell")
                break
            }
        }
    }
    
    /// 售票
    /// semaphore实现 线程安全
    func safeSellTicket() {
        while true {
            // 信号-1，当为0时，等待
            ticketSempaphore.wait()
            if (tickets > 0) {
                tickets -= 1
                let thread = String.init(format: "%p", getCurrentThread())
                print("余票\(tickets), thread: \(thread)")
            } else {
                print("end sell")
                ticketSempaphore.signal()
                break
            }
            // 继续
            ticketSempaphore.signal()
        }
    }
}

// MARK: - 测试
extension ViewController {
    private func whileNum() {
        var num = 0
        let semaphore = DispatchSemaphore.init(value: 0)
        while num < 5 {
            getGlobalQueue().async {
                num += 1
                semaphore.signal()
            }
            semaphore.wait()
        }
        print("num = \(num)")
    }
    
    private func appendArr() {
        var arr = [Int]()
        let serialQueue = createSerialQueue(label: "concurrent")
        let group = DispatchGroup()
        for i in 0..<1000 {
            group.enter()
            serialQueue.async {
                arr.append(i)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            print("arr count: \(arr.count)")
        }
    }
    
    func numTask1() {
        // 串行队列异步执行，不会创建新线程
        // 在线程内部，按照任务添加顺序执行
        // 如果有异步任务
        let queue = createSerialQueue(label: "serial")
        print(1)
        queue.async {
            print(2)
            queue.async {
                print(3)
            }
            print(4)
        }
        print(5)
    }
}

// MARK: - 死锁测试
extension ViewController {
    /// deadLock1在主线程中执行，2任务同步添加到主线程中
    /// 2要等待deadLock1完成才能执行，deadLock1要等待2完成才能完成
    /// 发生死锁
    func deadLock1() {
        print(1)
        
        /* 3等2，2在全局队列，所以不会死锁
        getGlobalQueue().sync {
            print(2)
        }
        */
        getMainQueue().sync {
            print(2)
        }
        print(3)
    }
    
    
    func deadLock2() {
        let serialQueue = createSerialQueue(label: "com.serial.queue")
        print(1)
        serialQueue.async {
            print(2)
            // 同一个串行队列中添加同步任务死锁
            serialQueue.sync {
                print(3)
            }
            print(4)
        }
        print(5)
    }
    
    func deadLock3() {
        print(1)
        getGlobalQueue().async {
            print(2)
            getMainQueue().sync {
                print(3)
            }
            print(4)
        }
        print(5)
    }
}
