//
//  NullStore.swift
//  EssentialApp
//
//  Created by 宇高あゆみ on 2022/09/02.
//

import Foundation
import EssentialFeed

class NullStore: FeedStore {
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        completion(.success(()))
    }
    
    func insert(_ feed: [EssentialFeed.LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        completion(.success(()))
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.success(.none))
    }
}

extension NullStore: FeedImageDataStore {
    func retrieve(dataForUrl url: URL) throws -> Data? { .none }
    
    func insert(data: Data, for url: URL) throws {}
}
