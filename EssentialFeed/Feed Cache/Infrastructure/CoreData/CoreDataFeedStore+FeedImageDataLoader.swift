//
//  CoreDataFeedStore+FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/04/23.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {
    public func retrieve(dataForUrl url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        completion(.success(.none))
    }
    
    public func insert(data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        
    }
}
