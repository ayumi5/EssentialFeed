//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by 宇高あゆみ on 2022/04/28.
//

import Foundation
import EssentialFeed

public final class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache
    
    public init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = decoratee.loadImageData(from: url) { [weak self] result in
            completion(result.map { [weak self] data in
                self?.cache.saveIgnoringResult(data, for: url)
                return data
            })
        }
        return task
    }
}

private extension FeedImageDataCache {
    func saveIgnoringResult(_ data: Data, for url: URL) {
        save(data, for: url) { _ in }
    }
}
