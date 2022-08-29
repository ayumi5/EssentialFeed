//
//  ImageCommentsEndpoint.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/08/27.
//

import Foundation

public enum ImageCommentEndPoint {
    case get(UUID)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("v1/image/\(id)/comments")
        }
    }
}
