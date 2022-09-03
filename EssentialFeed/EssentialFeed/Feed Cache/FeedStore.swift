//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/01/31.
//

import Foundation

public struct CachedFeed {
    public var feed: [LocalFeedImage]
    public var timestamp: Date
    
    public init(feed: [LocalFeedImage], timestamp: Date) {
        self.feed = feed
        self.timestamp = timestamp
    }
}

public protocol FeedStore {
    func deleteCachedFeed() throws
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws
    func retrieve() throws -> CachedFeed?
}
