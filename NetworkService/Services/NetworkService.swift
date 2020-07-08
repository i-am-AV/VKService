//
//  NetworkService.swift
//  VkNewsFeed
//
//  Created by  Alexander on 08.06.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import Foundation

protocol Networking {
    
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> ()) // создает URL из path и params
}

final class NetworkService: Networking {
    
    private let authService: AuthService
    
    init(authServive: AuthService) {
        self.authService = authServive
    }
    
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> ()) {
        
        guard let token = authService.token else { return }
        
        var allParams = params
        
        allParams["access_token"] = token
        allParams["v"] = API.version
        
        let url = self.url(from: path, params: allParams)
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        
        task.resume() // для запуска
    }
    
    private func createDataTask (from request: URLRequest, completion: @escaping (Data?, Error?) -> ()) -> URLSessionDataTask {
        
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async() {
                completion(data, error)
            }
        }
    }
    
    private func url(from path: String, params: [String: String]) -> URL {
        
        var components = URLComponents()
        
        components.scheme = API.scheme
        components.host = API.host
        components.path = API.messages
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        
        return components.url!
        
    }
}
