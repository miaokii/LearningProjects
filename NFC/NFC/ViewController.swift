//
//  ViewController.swift
//  NFC
//
//  Created by miaokii on 2020/1/6.
//  Copyright © 2020 ly. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UIViewController {
    
    private var nfcSession: NFCTagReaderSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nfcSession = NFCTagReaderSession.init(pollingOption: [.iso14443, .iso15693], delegate: self, queue: nil)
    }

    @IBAction func nfcScan(_ sender: Any) {
        nfcSession.begin()
    }
}

extension ViewController: NFCTagReaderSessionDelegate {
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("开始阅读")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print("didDetect \(tags)")
    }
}

extension ViewController: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print(messages)
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("开始阅读")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        print("didDetect \(tags)")
    }
}
