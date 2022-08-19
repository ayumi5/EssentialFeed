//
//  FeedImageDataMapper.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/08/19.
//

import Foundation

final public class FeedImageDataMapper {
    enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, response: HTTPURLResponse) throws -> Data {
        guard response.isOK && !data.isEmpty else {
            throw Error.invalidData
        }
        
        return data
    }
}
