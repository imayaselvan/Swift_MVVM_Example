//
//  ApiManager.swift
//  Flickr
//
//  Created by Imayaselvan Ramakrishnan on 30/01/19.
//  Copyright © 2019 Imayaselvan Ramakrishnan. All rights reserved.
//

import UIKit

enum ApiRequestError: Error {
    case noInternetConnection
    case timeOutConnection
    case incorrectResponseFormat
    case incorrectUrlFormat
    case incorrectParameters
    case notFound // 404
    case badRequest //400
    case parsingError
    case unknowErrorCode(errorCode: Int)
}

class ApiManager: NSObject {
    
    lazy var session: URLSession = {
       var sc = URLSessionConfiguration.default
       sc.httpAdditionalHeaders = [:]
       sc.timeoutIntervalForRequest = 15
       sc.httpCookieStorage = HTTPCookieStorage.shared
       return URLSession(configuration: sc)
    }()
    
    override init() {
        super.init()
    }
    
    func sendRequest<T: Decodable>(request: URLRequest, success:@escaping (T) -> Void, failure: @escaping (ApiRequestError) -> Void ) {
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let response = response as? HTTPURLResponse {
                //TODO: handle proper error code
                if response.statusCode != 200 {
                    failure(.incorrectUrlFormat)
                } else {
                    //Hack.- For now check only success case
                    if let responseObj = try? JSONDecoder().decode(T.self, from: data!) {
                        success(responseObj)
                    }else {
                        failure(.incorrectResponseFormat)
                    }
                }
            } else {
                failure(.incorrectUrlFormat)
            }
        })
        task.resume()
    }
    

    func getUrlRequest(url: String, params: [String: String]? = nil, headers: [String: String]? = nil) -> URLRequest? {
        
        guard let url = try? constructURL(url, params: params) else { return nil }
//        let url = URLBuilder.init().set(host: "").set(path: "").build()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    private func constructURL(_ urlString: String, params: [String: String]?) throws -> URL {
    
        guard let url = URL(string: urlString) else { throw ApiRequestError.badRequest }
        guard let params = params else { return url }
        
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponent?.queryItems = params.map({ return URLQueryItem(name: $0, value: $1) })
        
        guard let finalURL = urlComponent?.url else { throw ApiRequestError.badRequest }
        return finalURL
    }
}


