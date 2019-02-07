//
//  Webservice.swift
//  Tapptic
//
//  Created by Lilian on 23/01/2019.
//  Copyright © 2019 Lilian. All rights reserved.
//

import Foundation

enum ResultList<ObjectResponse> {
    case success([ObjectModel])
    case failure(NSError)
}

enum ResultDetail<ObjectResponse> {
    case success(ObjectModel)
    case failure(NSError)
}

extension URLSession {
    
    func requestObjectList(completion: @escaping (ResultList<[ObjectModel]>) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
            
        session.dataTask(with: NetworkConfiguration.listUrl) { (data, response, error) -> Void in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                let errorDescription = ErrorState.from(statusCode: httpResponse.statusCode).description
                let error = NSError(domain: errorDescription, code: httpResponse.statusCode, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {
                if let error = error as NSError? {
                    let errorDescription = ErrorState.from(statusCode: error.code).description
                    let error = NSError(domain: errorDescription, code: error.code, userInfo: nil)
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                } else {
                    let errorDescription = ErrorState.defaultError.description
                    let error = NSError(domain: errorDescription, code: 0, userInfo: nil)
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
                return
            }
            do {
                let objects = try JSONDecoder().decode([ObjectModel].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(objects))
                }
            } catch  {
                print("error trying to convert data to JSON")
                let errorDescription = ErrorState.unknownError.description
                let error = NSError(domain: errorDescription, code: 0, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func requestDetailText(name: String, completion: @escaping (ResultDetail<ObjectModel>) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let url = URL(string: NetworkConfiguration.detailsUrl + name)!
        session.dataTask(with: url) { (data, response, error) -> Void in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                let errorDescription = ErrorState.from(statusCode: httpResponse.statusCode).description
                let error = NSError(domain: errorDescription, code: httpResponse.statusCode, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {
                if let error = error as NSError? {
                    let errorDescription = ErrorState.from(statusCode: error.code).description
                    let error = NSError(domain: errorDescription, code: error.code, userInfo: nil)
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                } else {
                    let errorDescription = ErrorState.defaultError.description
                    let error = NSError(domain: errorDescription, code: 0, userInfo: nil)
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
                return
            }
            do {
                let object = try JSONDecoder().decode(ObjectModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(object))
                }
            } catch  {
                print("error trying to convert data to JSON")
                let errorDescription = ErrorState.unknownError.description
                let error = NSError(domain: errorDescription, code: 0, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    
}
