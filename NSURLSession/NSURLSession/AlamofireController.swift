//
//  AlamofireController.swift
//  NSURLSession
//
//  Created by miaokii on 2021/5/13.
//

import UIKit
import Alamofire

let kyToken = "ad8a9eda-315b-4460-ac1c-63523c389ada"
class AlamofireController: UIViewController {

    var session: Session!
    var imageURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        session = Session.init(configuration: config)
        
        writeLocalFile()
    }
    
    private func writeLocalFile() {
        let fileName = String.decimal(value: Date().timeIntervalSince1970)+".jpg"
        SandBoxManager.write(image: UIImage.init(named: "headImg")!, name: fileName) { [weak self] (url) in
            self?.imageURL = url
        }
    }
    
    @IBAction func getRequest(_ sender: Any) {
        HUD.show()
        session.request("https://www.baidu.com", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            guard let data = response.data else {
                HUD.flash(error: response.error)
                return
            }
            
            let string = String.init(data: data, encoding: .utf8)
            HUD.flash(hint: string)
        }
    }
    
    @IBAction func postRequest(_ sender: Any) {
        let url = "http://pre.panzh.zljtys.com/kyhz/user/api/update"
        let header = HTTPHeaders.init([.init(name: "token", value: kyToken)])
        let param = ["id":"aee1965b-5d97-46f4-96a9-ab31c55b5d52", "nickName": String.randomStr(len: 20)]
        let paramString = String.init(data: try! JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed), encoding: .utf8)!
        
        HUD.show()
        session.request(url, method: .post, parameters: ["data": paramString], headers: header).responseJSON { response in
            guard let data = response.data else {
                HUD.flash(error: response.error)
                return
            }
            
            let string = String.init(data: data, encoding: .utf8)
            HUD.flash(hint: string)
        }
    }
    
    @IBAction func uploadData(_ sender: Any) {
        
        let url = "http://pre.panzh.zljtys.com/kyhz/user/api/update"
        guard let imgData = UIImage.init(named: "head")?.jpegData(compressionQuality: 1) else {
            return
        }
        let header = HTTPHeaders.init([.init(name: "token", value: kyToken)])
        let param = ["id":"aee1965b-5d97-46f4-96a9-ab31c55b5d52"]
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed)
        
        HUD.show()
        session.upload(multipartFormData: { formData in
            formData.append(imgData, withName: "file", fileName: nil, mimeType: "image/*")
            formData.append(paramData, withName: "data")
        }, to: url, method: .post, headers: header).responseJSON { response in
            guard let data = response.data else {
                HUD.flash(error: response.error)
                return
            }
            
            let string = String.init(data: data, encoding: .utf8)
            HUD.flash(hint: string)
        }
    }
    
    @IBAction func uploadFile(_ sender: Any) {
        
        let url = "http://pre.panzh.zljtys.com/kyhz/user/api/update"
        let header = HTTPHeaders.init([.init(name: "token", value: kyToken)])
        let param = ["id":"aee1965b-5d97-46f4-96a9-ab31c55b5d52"]
        
        var request = URLRequest.init(url: URL.init(string: url)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = header.dictionary
        
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed)
        
        session.upload(multipartFormData: { formData in
            // 上传图像文件
            formData.append(self.imageURL, withName: "file")
            // 其他参数
            formData.append(paramData, withName: "data")
        }, with: request).responseJSON { response in
            guard let data = response.data else {
                HUD.flash(error: response.error)
                return
            }
            
            let string = String.init(data: data, encoding: .utf8)
            HUD.flash(hint: string)
        }
    }
    
    @IBAction func uploadVideo(_ sender: Any) {
        
    }
    
}
