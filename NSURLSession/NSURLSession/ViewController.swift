//
//  ViewController.swift
//  NSURLSession
//
//  Created by miaokii on 2021/5/11.
//

import UIKit

let token = "1431102e-2175-4af8-8bf5-639f32b37053"
class ViewController: UIViewController {

    var shareSession = URLSession.shared
    var backgroundSession: URLSession!
    var session: URLSession!
    var defaultConfig = URLSessionConfiguration.default
    var backgroundConfig = URLSessionConfiguration.background(withIdentifier: "urlsession.background")
    var responseData = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultConfig.timeoutIntervalForRequest = 15
        defaultConfig.timeoutIntervalForResource = 15
        
        session = URLSession.init(configuration: defaultConfig, delegate: self, delegateQueue: nil)
        backgroundSession = URLSession.init(configuration: backgroundConfig)
    }

    @IBAction func getRequest(_ sender: Any) {
        HUD.show()
        let dataTask = session.dataTask(with: URL.init(string: "https://www.baidu.com")!) { data, response, error in
            guard let data = data else {
                HUD.flash(error: error)
                return
            }
            HUD.flash(hint: String.init(data: data, encoding: .utf8))
        }
        dataTask.resume()
    }
    
    @IBAction func postRequest(_ sender: Any) {
        
        let url = "http://pre.panzh.zljtys.com/kyhz/user/api/update"
        
        var request = URLRequest.init(url: URL.init(string:  url)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
                                       "token": kyToken]
        
        let param = ["id":"aee1965b-5d97-46f4-96a9-ab31c55b5d52", "nickName": String.randomStr(len: 20)]
        let paramString = String.init(data: try! JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed), encoding: .utf8)!
        let dataString = """
data=\(paramString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
"""
        
        let data = dataString.data(using: .ascii)
        
        request.httpBody = data
        
        HUD.show()
        let postTask = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                HUD.flash(error: error)
                return
            }
            HUD.flash(hint: String.init(data: data, encoding: .utf8))
        }
        postTask.resume()
    }
    
    
    @IBAction func uploadData(_ sender: Any) {
        
        guard let imgData = UIImage.init(named: "head")?.jpegData(compressionQuality: 1) else {
            return
        }
        
        let param = ["id":"aee1965b-5d97-46f4-96a9-ab31c55b5d52"]
        let paramString = String.init(data: try! JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed), encoding: .utf8)!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL.init(string: "http://pre.panzh.zljtys.com/kyhz/user/api/update")!
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        
        let header = [
            "Content-Type": "multipart/form-data; charset=utf-8; boundary=\(boundary)",
            "token": kyToken
        ]
        request.allHTTPHeaderFields = header
        
        let taskData = buildHeadImage(data: imgData, param: ["data": paramString])
        
        let uploadTask = session.uploadTask(with: request, from: taskData) { data, response, error in
            guard let data = data else {
                HUD.flash(error: error)
                return
            }
            HUD.flash(hint: String.init(data: data, encoding: .utf8))
        }
        uploadTask.resume()
    }
    
    @IBAction func uploadFile(_ sender: Any) {
        
    }
    
    @IBAction func uploadVideo(_ sender: Any) {
        
    }
}


// 分段边界
private let boundary = "upload.boundary"
// 换行
private let crlf = "\r\n"

private let dataContentDisposition = "Content-Disposition: form-data;"
private let contentType = "Content-Type:"

extension ViewController {
    private func buildHeadImage(data: Data, param: [String: Any]) -> Data {
        
        guard !data.isEmpty else {
            return data
        }
        
        var formData = Data()
        var formString = ""
        
        // data参数
        formString += "--"+boundary+crlf
        formString += dataContentDisposition+" name=\"data\""+crlf
        formString += (param["data"] as! String)+crlf
        
        // 图片数据
        formString += "--"+boundary+crlf
        formString += dataContentDisposition+" name=\"file\""+crlf
        formString += contentType+" image/*"+crlf
        
        // 拼接
        formData.append(formString.data(using: .utf8)!)
        // 拼接图片数据
        formData.append(data)
        
        // 结束行
        let end = crlf+"--"+boundary+"--"+crlf
        formData.append(end.data(using: .utf8)!)
        return formData
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

