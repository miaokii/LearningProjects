//
//  MachPortController.swift
//  RunLoop
//
//  Created by miaokii on 2021/6/1.
//

import UIKit

class MachPortController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func launchThread() {
        let port = NSMachPort.init()
        port.setDelegate(self)
        RunLoop.current.add(port, forMode: .default)
        let work = WorkClass.init()
        let thread = Thread.init {
            work.launchThreadWith(port: port)
        }
        thread.start()
    }
}

import Foundation
extension MachPortController: NSMachPortDelegate {
    
    func handleMachMessage(_ msg: UnsafeMutableRawPointer) {
        
    }
}

fileprivate let kMsg1 = 100
fileprivate let kMsg2 = 101

class WorkClass: NSObject, PortDelegate {
    
    var remotePort: Port!
    var myPort: Port!
    
    func launchThreadWith(port: Port) {
        autoreleasepool {
            remotePort = port
            Thread.current.name = "WorkClass Thread"
            RunLoop.current.run()
            
            myPort = Port.init()
            myPort.setDelegate(self)
            RunLoop.current.add(myPort, forMode: .default)
            self.sendPortMessage()
        }
    }
    
    private func sendPortMessage() {
        let arr: NSMutableArray = .init(array: ["1", "2"])
        remotePort.send(before: Date(),
                        msgid: kMsg1,
                        components: arr,
                        from: myPort,
                        reserved: 0)
    }
    
    
}
