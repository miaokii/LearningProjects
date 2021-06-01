//
//  RunLoopSources.swift
//  RunLoop
//
//  Created by miaokii on 2021/5/31.
//

import Foundation

class CustomRunLoopSource: NSObject {
    
    var source: CFRunLoopSource!
    var commands = [String]()
    
    override init() {
        super.init()
        
        var context = CFRunLoopSourceContext.init(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil, equal: nil, hash: nil) { p, cf, mode in
            
            guard let source = p?.load(as: CustomRunLoopSource.self),
                  let cf = cf else {
                return
            }
            let delegate = MKAppDelegate.share
            let context = CusRunLoopContext.init(runLoop: cf, source: source)
            DispatchQueue.main.async {
                delegate.register(sourceInfo: context)
            }
        } cancel: { p, cf, mode in
            guard let source = p?.load(as: CustomRunLoopSource.self),
                  let cf = cf else {
                return
            }
            let delegate = MKAppDelegate.share
            let context = CusRunLoopContext.init(runLoop: cf, source: source)
            DispatchQueue.main.async {
                delegate.remove(source: context)
            }
        } perform: { p in
            guard let source = p?.load(as: CustomRunLoopSource.self) else {
                return
            }
            source.sourceFired()
        }
        source = CFRunLoopSourceCreate(kCFAllocatorNull, 0, &context)
    }
    
    func addToCurrentRunLoop() {
        let runLoop = CFRunLoopGetCurrent()
        CFRunLoopAddSource(runLoop, source, .defaultMode)
    }
    
    func inValidate() {
        
    }
    
    func sourceFired() {
        
    }
    
    func add(command: Int, with data: Data)  {
        
    }
    
    func fireAllCompandsSource(on runLoop: CFRunLoop) {
        
    }
}

class CusRunLoopContext: NSObject {
    var runLoop: CFRunLoop!
    var source: CustomRunLoopSource!
    
    convenience init(runLoop: CFRunLoop, source: CustomRunLoopSource) {
        self.init()
        self.runLoop = runLoop
        self.source = source
    }
}


class MKAppDelegate: NSObject {
    static let share = MKAppDelegate.init()
    
    var sourcesToPing = [CusRunLoopContext]()
    
    @objc func register(sourceInfo: CusRunLoopContext) {
        sourcesToPing.append(sourceInfo)
    }
    
    @objc func remove(source: CusRunLoopContext) {
        sourcesToPing.removeAll(where: { $0.isEqual(source) })
    }
}
