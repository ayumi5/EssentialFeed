//
//  RemoteImageCommentLoader.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/08/11.
//

import Foundation

public typealias RemoteImageCommentLoader = RemoteLoader<[ImageComment]>

public extension RemoteImageCommentLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: ImageCommentMapper.map)
    }
}
