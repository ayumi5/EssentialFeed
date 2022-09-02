//
//  CoreDataFeedStore+FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/04/23.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {
    public func retrieve(dataForUrl url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        performAsync  { context in
            completion(Result {
                try ManagedFeedImage.data(with: url, in: context)
            })
        }
    }
    
    public func insert(data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        performAsync  { context in
            completion(Result {
                try ManagedFeedImage.first(with: url, in: context)
                    .map { $0.data = data }
                    .map(context.save)
            })
        }
    }
}
