//
//  AlamofireController.swift
//  NSURLSession
//
//  Created by miaokii on 2021/5/13.
//

import UIKit
import Alamofire

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
        let url = "http://192.168.7.12/pension-service-api/api/staff/login"
        let param = ["type":"1","tel":"13688421393","password":"123456"]
        
        HUD.show()
        session.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            guard let data = response.data else {
                HUD.flash(error: response.error)
                return
            }
            
            let string = String.init(data: data, encoding: .utf8)
            HUD.flash(hint: string)
        }
    }
    
    @IBAction func uploadData(_ sender: Any) {
        let url = "http://192.168.7.12/pension-service-api/api/staff/upload?userId=32"
        guard let imgData = UIImage.init(named: "headImg")?.jpegData(compressionQuality: 1) else {
            return
        }
        let header = HTTPHeaders.init([.init(name: "token", value: "2a7d677f-bdd2-4360-aeed-146032fc96e7")])
        
        HUD.show()
        session.upload(multipartFormData: { formData in
            formData.append(imgData, withName: "file", fileName: nil, mimeType: "image/*")
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
        
        let url = "http://192.168.7.12/pension-service-api/api/staff/upload?userId=32"
        let header = HTTPHeaders.init([.init(name: "token", value: "2a7d677f-bdd2-4360-aeed-146032fc96e7")])
        
        /*
        HUD.show()
        session.upload(multipartFormData: { formData in
            formData.append(self.imageURL, withName: "file")
        }, to: url, method: .post, headers: header).responseJSON { response in
            guard let data = response.data else {
                HUD.flash(error: response.error)
                return
            }
            
            let string = String.init(data: data, encoding: .utf8)
            HUD.flash(hint: string)
        }
         */
        
        
        let url1 = "http://192.168.7.12/pension-service-api/api/staff/upload"
        let praram = ["userId": "32"]
        var request = URLRequest.init(url: URL.init(string: url1)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = header.dictionary
        request.httpBody = try? JSONSerialization.data(withJSONObject: praram, options: .fragmentsAllowed)
        
        session.upload(multipartFormData: { formData in
            formData.append(self.imageURL, withName: "file")
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
