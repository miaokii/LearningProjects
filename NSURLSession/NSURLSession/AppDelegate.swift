//
//  AppDelegate.swift
//  NSURLSession
//
//  Created by miaokii on 2021/5/11.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var backgroundSessionComplete: (()->Void)?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(SandBoxManager.multipartFilePath())
        regisigerNotification()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        
        if identifier == backgroundSessionId {
            backgroundSessionComplete = completionHandler
        }
    }

}

extension AppDelegate {
    private func regisigerNotification(){
          UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("All set!")
        } else if let error = error {
            print(error.localizedDescription)
        }
          }
    }
}

extension String{
    static let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static func randomStr(len : Int) -> String{
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
            ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
}

func popLocalotification() {
    let unNotification = UNMutableNotificationContent.init()
    unNotification.title = "下载结束"
    unNotification.subtitle = "您有一个新任务已经下载结束"
    unNotification.sound = .default
    let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest.init(identifier: backgroundSessionId, content: unNotification, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}
