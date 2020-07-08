//
//  AppDelegate.swift
//  NetworkService
//
//  Created by  Alexander on 08.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import UIKit
import VKSdkFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
    
    // MARK: - Инициализация SDK
    
//    Функция для открытия URL. Явно указывает, какую ссылку открывать при авторизации или регистрации 
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        
        return true
    }
    
}


