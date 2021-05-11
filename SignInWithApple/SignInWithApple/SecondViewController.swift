//
//  SecondViewController.swift
//  SignApple
//
//  Created by miaokii on 2020/3/18.
//  Copyright © 2020 ly. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    private var resultLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        
        resultLabel.textColor = .darkText
        resultLabel.frame = .init(x: 10, y: 20, width: view.frame.width - 20, height: view.frame.height * 0.8)
        view.addSubview(resultLabel)
        resultLabel.numberOfLines = 0
        
        if KeychainItem.currentUserIdentifier.count > 0 {
            resultLabel.text = "userId: \(KeychainItem.currentUserIdentifier)"
        }
        
        let signOutBtn = UIButton.init()
        signOutBtn.setTitle("注销登录", for: .normal)
        signOutBtn.setTitleColor(.blue, for: .normal)
        signOutBtn.frame = .init(x: resultLabel.frame.minX, y: resultLabel.frame.maxY, width: resultLabel.frame.width, height: 40)
        signOutBtn.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        view.addSubview(signOutBtn)
    }
    
    @objc private func signOut() {
        KeychainItem.deleteUserIdentifierFromKeychain()
        resultLabel.text = ""
        
        
        showLoginController()
    }
    
    func set(user: String, email: String?, code: Data?, token: Data?) {
        let attributeString = NSMutableAttributedString.init()
        attributeString.append(.init(string: "userId: \(user)"))
        
        if let e = email {
            attributeString.append(.init(string: "\nemail: \(e)"))
        }
        
        if let co = code, let cos = String.init(data: co, encoding: .utf8) {
            attributeString.append(.init(string: "\ncode: \(cos)"))
        }
        
        if let to = token, let tos = String.init(data: to, encoding: .utf8) {
            attributeString.append(.init(string: "\ntoken: \(tos)"))
        }
        
        let paraStyle = NSMutableParagraphStyle.init()
        paraStyle.lineSpacing = 5
        attributeString.addAttributes([.paragraphStyle : paraStyle], range: NSRange.init(location: 0, length: attributeString.length))
        
        resultLabel.attributedText = attributeString
    }
}
