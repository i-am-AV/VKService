//
//  AuthService.swift
//  NetworkService
//
//  Created by  Alexander on 08.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import Foundation
import VKSdkFramework

// MARK:- Interface
protocol AuthServiceDelegate: class {
    func authServiceShouldShow(viewController: UIViewController)
    func authServiceSignIn()
    func authServiceSignInDidFail()
}

// MARK:- Implementation
class AuthService: NSObject {
    
    private let appId = "7503511"
    private let vkSdk: VKSdk
    
    weak var delegate: AuthServiceDelegate?
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    func wakeUpSession() {
        let scope = ["messages"] // список прав доступа
        
        VKSdk.wakeUpSession(scope) { [weak delegate] (state, error) in
            switch state {
            case .initialized:
                VKSdk.authorize(scope)
                print("initialized")
            case .authorized:
                print("authorized")
                delegate?.authServiceSignIn()
            default:
                delegate?.authServiceSignInDidFail()
            }
        }
    }
}

// MARK:- Delegates implementation

//Реализуем обязательные протоколы для VK SDK

extension AuthService: VKSdkDelegate, VKSdkUIDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        
        if result.token != nil {
            delegate?.authServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
        
        delegate?.authServiceSignInDidFail()
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        
        delegate?.authServiceShouldShow(viewController: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
}
