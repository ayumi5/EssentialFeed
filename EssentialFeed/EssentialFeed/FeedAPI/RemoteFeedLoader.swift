//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2021/12/22.
//

import Foundation

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

public extension RemoteFeedLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: FeedItemsMapper.map)
    }
}
