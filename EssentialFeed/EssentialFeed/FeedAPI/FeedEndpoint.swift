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
            return baseURL.appendingPathComponent("v1/feed")
        }
    }
}
