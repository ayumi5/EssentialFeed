//
//  ImageCommentMapper.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/08/11.
//

import Foundation

internal final class ImageCommentMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard isOK(response), let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteImageCommentLoader.Error.invalidData
        }
        return root.items
    }
    
    private static func isOK(_ response: HTTPURLResponse) -> Bool {
        (200...299).contains(response.statusCode)
    }
}
