//
//  ViewController.swift
//  RunLoop
//
//  Created by miaokii on 2021/5/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        launchNewThread()
    }
    
    func launchNewThread() {
        let thread = Thread.init(target: self, selector: #selector(threadSelector), object: nil)
        thread.name = "custom thread"
        thread.start()
    }
    
    @objc private func threadSelector() {
        print("task start")
        print(Date())
        let date = RunLoop.current.limitDate(forMode: .default)
        print(date)
        RunLoop.current.add(Port.init(), forMode: .default)
        RunLoop.current.run()
        print("task end")
        
        CFRunLoop
    }
    
}

