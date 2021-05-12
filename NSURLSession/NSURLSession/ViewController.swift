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
        getRequest()
    }
}

extension ViewController {
    
    func sessionConfig() {
        /*
         更改配置要生效与会话的话，需要重新创建会话
         */
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 10
        let session = URLSession.init(configuration: config)
        config.timeoutIntervalForResource = 20
        print(session.configuration.timeoutIntervalForResource)
        
        // 临时配置
        let _ = URLSessionConfiguration.ephemeral
        // 标识符创建，可以后台下载和上传任务，任务的传输移交给系统，专门进程处理任务，
        let _ = URLSessionConfiguration.background(withIdentifier: "download.sessionconfig")
    }
    
    func createSession() {
        /// 单例创建，和其他使用这个session的task共享连接和请求信息
        _ = URLSession.shared
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 15
        sessionConfiguration.timeoutIntervalForResource = 15
        _ = URLSession.init(configuration: sessionConfiguration)
        
        let session = URLSession.init(configuration: sessionConfiguration, delegate: self, delegateQueue: .current)
        session.invalidateAndCancel()
    }
    
    func getRequest() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 15
        sessionConfiguration.timeoutIntervalForResource = 15
        let session = URLSession.init(configuration: sessionConfiguration, delegate: self, delegateQueue: .current)
//        let dataTask = session.dataTask(with: URL.init(string: "https://www.baidu.com")!) { data, response, error in
//            print(String.init(data: data!, encoding: .utf8))
//        }
        let dataTask = session.dataTask(with: URL.init(string: "https://www.jd.com")!)
        
        dataTask.resume()
    }
}

extension ViewController: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("recive data ----> \(String(describing: String.init(data: data, encoding: .utf8)))")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        print("metrics ----> \(metrics.description)")
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("recive response ----> \(response))")
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("recive error ----> \(String(describing: error?.localizedDescription ?? ""))")
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        print("become downloadTask ----> \(downloadTask)")
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        print("become streamTask ----> \(streamTask)")
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        print("will cache response ----> \(proposedResponse)")
    }
}

