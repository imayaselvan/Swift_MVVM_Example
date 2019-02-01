//
//  ApiEndPoints.swift
//  Flickr
//
//  Created by Imayaselvan Ramakrishnan on 30/01/19.
//  Copyright © 2019 Imayaselvan Ramakrishnan. All rights reserved.
//

import Foundation

enum Environment {
    case dev
    case prod
    
    var baseUrl: String {
        switch self {
        case .dev: return "dev URL"
        case .prod: return "https://api.flickr.com/"
        }
    }
}

struct API {
    static let baseUrl = "https://api.flickr.com/"
}

struct Configuration {
    static let flickrKey      = "f2ddfcba0e5f88c2568d96dcccd09602"
    static let listingPerPage =  50
}

protocol ApiEndPoints {
    var path: String { get }
    var url: String { get }
}

enum Endpoints {
    enum Movies: ApiEndPoints {

        case fetch(String, Int)

        public var path: String {
            switch self {
            case .fetch(let query, let page):
                return "services/rest/?method=flickr.photos.search&api_key=\(Configuration.flickrKey)&format=json&nojsoncallback=1&safe_search=1&per_page=\(Configuration.listingPerPage)&text=\(query.encodedString())&page=\(page)"
            }
            
        }
        
        public var url: String {
            switch self {
            case .fetch: return "\(API.baseUrl)\(path)"
            }
        }
    }
}
