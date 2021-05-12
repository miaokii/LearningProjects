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
        postReqeust()
    }
    
    var responseData = Data()
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
//        let session = URLSession.init(configuration: sessionConfiguration, delegate: self, delegateQueue: .current)
//        let dataTask = session.dataTask(with: URL.init(string: "https://www.baidu.com")!) { data, response, error in
//            guard let data = data else {
//                print(error?.localizedDescription ?? "")
//                return
//            }
//            print(String.init(data: data, encoding: .utf8)!)
//        }
        let session = URLSession.init(configuration: sessionConfiguration, delegate: self, delegateQueue: .current)
        let dataTask = session.dataTask(with: URL.init(string: "https://www.baidu.com")!)
        dataTask.resume()
        
        session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            print("all dataTaks ----> \(dataTasks)")
        }
    }
    
    func postReqeust() {
        let session = URLSession.shared
        var request = URLRequest.init(url: .init(string: "http://192.168.7.12/pension-service-api/api/staff/login")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        let bodyDic = ["type":"1","tel":"13688421393","password":"123456"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyDic, options: .fragmentsAllowed)
        
        let postTask = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "")
                return
            }
            print(String.init(data: data, encoding: .utf8)!)
        }
        postTask.resume()
    }
}

extension ViewController: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        responseData.append(data)
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
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let err = error {
            print(err.localizedDescription)
            return
        }
        print(String.init(data: responseData, encoding: .utf8)!)
    }
    
    /// 重定向
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(request)
    }
}

