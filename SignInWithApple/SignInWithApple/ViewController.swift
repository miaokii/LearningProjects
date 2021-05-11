//
//  ViewController.swift
//  SignApple
//
//  Created by miaokii on 2020/3/18.
//  Copyright © 2020 ly. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            let appleIdBtn = ASAuthorizationAppleIDButton.init(type: .signIn, style: .whiteOutline)
            let center = view.center
            let size = CGSize.init(width: view.frame.width * 0.7, height: 40)
            let point = CGPoint.init(x: center.x - size.width / 2, y: center.y * 0.5)
            appleIdBtn.frame = .init(origin: point, size: size)
            appleIdBtn.addTarget(self, action: #selector(signApple(_:)), for: .touchUpInside)
            view.addSubview(appleIdBtn)
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestAppleIdRequest()
    }
    
    @objc func signApple(_ sender: Any) {
        let appleIdProvider = ASAuthorizationAppleIDProvider.init()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController.init(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    /// 发起appleid_password登陆请求
    private func requestAppleIdRequest() {
        let request = [ASAuthorizationAppleIDProvider().createRequest(),
                       ASAuthorizationPasswordProvider().createRequest()]
        let authorizationController = ASAuthorizationController.init(authorizationRequests: request)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let userId = appleIDCredential.user
            let email = appleIDCredential.email
            let code = appleIDCredential.authorizationCode
            let token = appleIDCredential.identityToken
//
            saveKeychain(name: userId)
            loginSuccess(user: userId, email: email, code: code, token: token)
            
        case let password as ASPasswordCredential:
            let user = password.user
            let pass = password.password
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: user, password: pass)
            }
        default:
            break
        }
    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
       let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
       let alertController = UIAlertController(title: "Keychain Credential Received",
                                               message: message,
                                               preferredStyle: .alert)
       alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
       self.present(alertController, animated: true, completion: nil)
   }
    
    private func saveKeychain(name: String) {
        do {
            try KeychainItem.init(account: "user").saveItem(name)
        } catch {
            print("unable save \(name) to keychain")
        }
    }
    
    private func loginSuccess(user: String, email: String?, code: Data?, token: Data?) {
        if let superVC = presentingViewController as? SecondViewController {
            superVC.set(user: user, email: email, code: code, token: token)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
