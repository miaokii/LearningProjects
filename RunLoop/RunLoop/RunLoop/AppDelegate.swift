//
//  AppDelegate.swift
//  RunLoop
//
//  Created by miaokii on 2021/5/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var fpsLabel: FPSLabel!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.backgroundColor = .white
        setFpsLabel()
        return true
    }
}

extension AppDelegate {
    func setFpsLabel() {
        let safeTop = window?.safeAreaInsets.top ?? 0
        let screenWidth = UIScreen.main.bounds.width
        let fpsWidth: CGFloat = 60
        let rect = CGRect.init(x: screenWidth - 50 - 20, y: safeTop + 10, width: fpsWidth, height: 20)
        fpsLabel = FPSLabel.init(frame: rect)
        fpsLabel.font = .systemFont(ofSize: 15)
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.window?.addSubview(self.fpsLabel)
        }
    }
}

