//
//  ViewController.swift
//  ListeningSource
//
//  Created by Miaokii on 2021/4/22.
//  Copyright © 2021 ly. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var source: DispatchSourceProcess!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 监听邮件app
        let mails = NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.mail")
        guard let mail = mails.first else {
            print("未找到 com.apple.mail")
            return
        }
        
        let pid = mail.processIdentifier
        source = DispatchSource.makeProcessSource(identifier: pid, eventMask: .all, queue: .main)
        source.setEventHandler {
            print(self.source.data)
        }
        source.resume()
    }

    override var representedObject: Any? {
        didSet {
        
        }
    }


}

