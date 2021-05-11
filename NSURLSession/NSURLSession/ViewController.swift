//
//  ViewController.swift
//  NSURLSession
//
//  Created by miaokii on 2021/5/11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createSession()
    }
}

extension ViewController {
    func createSession() {
        /// 单例创建，和其他使用这个session的task共享连接和请求信息
        _ = URLSession.shared
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 15
        sessionConfiguration.timeoutIntervalForResource = 15
        _ = URLSession.init(configuration: sessionConfiguration)
        
        _ = URLSession.init(configuration: sessionConfiguration, delegate: self, delegateQueue: .current)
    }
    
    func getRequest() {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: URL.init(string: "https://www.baidu.com")!) { data, response, error in
            print(String.init(data: data!, encoding: .utf8))
        }
        dataTask.resume()
    }
}

extension ViewController: URLSessionDelegate {
    
}

