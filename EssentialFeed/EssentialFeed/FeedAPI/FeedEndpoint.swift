//
//  FeedEndpoint.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/08/29.
//

import Foundation

public enum FeedEndPoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/v1/feed"
            components.queryItems = [
                URLQueryItem(name: "limit", value: "10")
            ]
            
            return components.url!
        }
    }
}
