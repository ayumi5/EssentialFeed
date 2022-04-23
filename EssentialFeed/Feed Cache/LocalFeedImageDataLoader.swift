//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/04/23.
//

import Foundation

public final class LocalFeedImageDataLoader {
    private final class Task: FeedImageDataLoaderTask {
        private var completion: ((FeedImageDataLoader.Result) -> Void)?
        
        public init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        public func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }
        
        public func cancel() {
            preventFurtherCompletions()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    public enum Error: Swift.Error {
        case failed
        case notFound
    }
    
    private let store: FeedImageDataStore
    
    public init(store: FeedImageDataStore) {
        self.store = store
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = Task(completion)
        store.retrieve(dataForUrl: url) { [weak self] result in
            guard self != nil else { return }
            task.complete(with: result
                        .mapError { _ in Error.failed }
                        .flatMap { data in data.map { .success($0) } ?? .failure(Error.notFound) })
        }
        return task
    }
}
