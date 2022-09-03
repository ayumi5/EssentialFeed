//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/04/28.
//

import Foundation

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}
