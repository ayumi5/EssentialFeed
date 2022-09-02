//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/04/28.
//

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
