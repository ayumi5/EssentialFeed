//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/04/23.
//

import Foundation

public protocol FeedImageDataStore {
    func retrieve(dataForUrl url: URL) throws -> Data?
    func insert(data: Data, for url: URL) throws
}
