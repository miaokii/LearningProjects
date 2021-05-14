//
//  ViewController.swift
//  NSURLSession
//
//  Created by miaokii on 2021/5/11.
//

import UIKit

let baseUrl = "https://mockapi.eolinker.com/33es19E1ff1417cde8d0e4d4ccd7d3e346b5983e5e656cb"


let token = "1431102e-2175-4af8-8bf5-639f32b37053"
class ViewController: AssetViewController {

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
        getUserInfo()
    }
    
    @IBAction func postRequest(_ sender: Any) {
        postLogin()
    }
    
    
    @IBAction func uploadData(_ sender: Any) {
        chooseImage(type: .video) {
            self.clipVideo()
        }
    }
    
    @IBAction func uploadFile(_ sender: Any) {

    }
    
    @IBAction func uploadVideo(_ sender: Any) {
    }
}

// MARK: - 模拟接口
extension ViewController {
    func getUserInfo() {
        let url = baseUrl + "/userInfo?id=123"
        HUD.show()
        let dataTask = session.dataTask(with: URL.init(string: url)!) { data, response, error in
            guard let data = data else {
                HUD.flash(error: error)
                return
            }
            HUD.flash(hint: String.init(data: data, encoding: .utf8))
        }
        dataTask.resume()
    }
    
    func postLogin()  {
        let url = baseUrl + "/login"
        var request = URLRequest.init(url: URL.init(string: url)!)
        request.httpMethod = "POST"
        
        let param = ["name": "kk",
                     "password": "23"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed)
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                HUD.flash(error: error)
                return
            }
            HUD.flash(hint: String.init(data: data, encoding: .utf8))
        }
        dataTask.resume()
    }
    
    func uploadImage() {
        guard let fileUrl = url, let imgData = try? Data.init(contentsOf: fileUrl) else {
            return
        }
        
        let param = ["data": "dasdfaf"]
        
        let url = URL.init(string: baseUrl+"/uploadImage")!
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        
        let header = [
            "Content-Type": "multipart/form-data; charset=utf-8; boundary=\(boundary)",
        ]
        request.allHTTPHeaderFields = header
        
        let taskData = buildHeadImage(data: imgData, param: param)
        
        let uploadTask = session.uploadTask(with: request, from: taskData) { data, response, error in
            guard let data = data else {
                print(error.debugDescription )
                return
            }
            print(String.init(data: data, encoding: .utf8) ?? "")
        }
        uploadTask.resume()
    }
    
    func clipVideo()  {
        
    }
}

// MARK: - ky康养护照
extension ViewController {
    
    /// 康养护照更新昵称
    func updateNickName() {
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
    
    /// 康养护照更新头像
    func updateHeadeImageByData() {
        guard let fileUrl = url, let imgData = try? Data.init(contentsOf: fileUrl) else {
            return
        }
        
        let dataParam = ["id":"aee1965b-5d97-46f4-96a9-ab31c55b5d52",
                         "nickName": "uzi"]
        let param = ["data": dataParam]
        
        let url = URL.init(string: "http://pre.panzh.zljtys.com/kyhz/user/api/update")!
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        
        let header = [
            "Content-Type": "multipart/form-data; charset=utf-8; boundary=\(boundary)",
            "token": kyToken
        ]
        request.allHTTPHeaderFields = header
        
        let taskData = buildHeadImage(data: imgData, param: param)
        
        let uploadTask = session.uploadTask(with: request, from: taskData) { data, response, error in
            guard let data = data else {
                print(error.debugDescription )
                return
            }
            print(String.init(data: data, encoding: .utf8) ?? "")
        }
        uploadTask.resume()
    }
    
    /// 康养护照更新文件头像
    func updateHeadImageByFile() {
        guard let imageURL = url else {
            return
        }
        let dataParam = ["id":"aee1965b-5d97-46f4-96a9-ab31c55b5d52",
                         "nickName": "uzi"]
        let param = ["data": dataParam]
        
        let url = URL.init(string: "http://pre.panzh.zljtys.com/kyhz/user/api/update")!
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        
        let header = [
            "Content-Type": "multipart/form-data; charset=utf-8; boundary=\(boundary)",
            "token": kyToken
        ]
        request.allHTTPHeaderFields = header
        request.httpBody = buildHeadFile(path: imageURL, param: param)
        
        let uploadTask = session.uploadTask(with: request, fromFile: imageURL) { data, response, error in
            guard let data = data else {
                print(error.debugDescription )
                return
            }
            print(String.init(data: data, encoding: .utf8) ?? "")
        }
        uploadTask.resume()
    }
}


// 分段边界
private let boundary = "upload.boundary"
// 换行
private let crlf = "\r\n"
// --
private let line = "--"

extension ViewController {
    private func buildHeadImage(data: Data, param: [String: Any]) -> Data {
        
        // 保存请求体数据
        var formData = Data()
        // 
        var formString = ""
        
        // 上传参数
        for (key, value) in param {
            guard let valueData = try? JSONSerialization.data(withJSONObject: value, options: .fragmentsAllowed),
                  let valueString = String.init(data: valueData, encoding: .utf8) else {
                continue
            }
            
            formString += line+boundary+crlf
            formString += "Content-Disposition: form-data; name=\"\(key)\""+crlf+crlf
            formString += valueString+crlf
        }
        
        // 上传数据信息
        formString += line+boundary+crlf
        formString += "Content-Disposition: form-data; name=\"file\""+crlf+crlf
        formString += "Content-Type: image/*"+crlf
        
        // 拼接参数和上传数据信息
        formData.append(formString.data(using: .utf8)!)
        // 拼接上传数据
        formData.append(data)
        
        // 结束行
        let end = crlf+line+boundary+line+crlf
        formData.append(end.data(using: .utf8)!)
        return formData
    }
    
    private func buildHeadFile(path: URL, param: [String: Any]) -> Data {
        
        let fileName = path.lastPathComponent
        
        let data = (try? Data.init(contentsOf: path)) ?? .init()
        
        // 保存请求体数据
        var formData = Data()
        //
        var formString = ""
        
        // 上传参数
        for (key, value) in param {
            guard let valueData = try? JSONSerialization.data(withJSONObject: value, options: .fragmentsAllowed),
                  let valueString = String.init(data: valueData, encoding: .utf8) else {
                continue
            }
            
            formString += line+boundary+crlf
            formString += "Content-Disposition: form-data; name=\"\(key)\""+crlf+crlf
            formString += valueString+crlf
        }
        
        // 上传数据信息
        formString += line+boundary+crlf
        formString += "Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\""+crlf+crlf
        formString += "Content-Type: image/*"+crlf
        
        // 拼接参数和上传数据信息
        formData.append(formString.data(using: .utf8)!)
        // 拼接上传数据
        formData.append(data)
        
        // 结束行
        let end = crlf+line+boundary+line+crlf
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

