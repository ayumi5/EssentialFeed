//
//  InMemoryFeedStore.swift
//  EssentialAppTests
//
//  Created by 宇高あゆみ on 2022/05/12.
//

import EssentialFeed

class InMemoryFeedStore: FeedStore {
    private(set) var feedCache: CachedFeed?
    private var feedImageDataCache: [URL:Data] = [:]
    
    private init(_ feedCache: CachedFeed? = nil) {
        self.feedCache = feedCache
    }
    
    func deleteCachedFeed() throws {
        feedCache = nil
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        feedCache = CachedFeed(feed: feed, timestamp: timestamp)
    }
    
    func retrieve() throws -> CachedFeed? {
        feedCache
    }
}

extension InMemoryFeedStore: FeedImageDataStore {
    func retrieve(dataForUrl url: URL) throws -> Data? {
        feedImageDataCache[url]
    }
    
    func insert(data: Data, for url: URL) throws {
        feedImageDataCache[url] = data
    }
}

extension InMemoryFeedStore {
    static var empty: InMemoryFeedStore {
        InMemoryFeedStore()
    }
    
    static var withExpiredFeedCache: InMemoryFeedStore {
        InMemoryFeedStore(CachedFeed(feed: [], timestamp: Date.distantPast))
    }
    
    static var withNonExpiredFeedCache: InMemoryFeedStore {
        InMemoryFeedStore(CachedFeed(feed: [], timestamp: Date()))
    }
}
