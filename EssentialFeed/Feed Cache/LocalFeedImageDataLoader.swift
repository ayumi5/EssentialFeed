//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/04/23.
//

import Foundation

public final class LocalFeedImageDataLoader {
    
    private let store: FeedImageDataStore
    
    public init(store: FeedImageDataStore) {
        self.store = store
    }
}

extension LocalFeedImageDataLoader: FeedImageDataLoader {
    public typealias LoadResult = FeedImageDataLoader.Result
    
    public enum LoadError: Swift.Error {
        case failed
        case notFound
    }
    
    private final class LoadImageDataTask: FeedImageDataLoaderTask {
        private var completion: ((LoadResult) -> Void)?
        
        public init(_ completion: @escaping (LoadResult) -> Void) {
            self.completion = completion
        }
        
        public func complete(with result: LoadResult) {
            completion?(result)
        }
        
        public func cancel() {
            preventFurtherCompletions()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    public func loadImageData(from url: URL, completion: @escaping (LoadResult) -> Void) -> FeedImageDataLoaderTask {
        let task = LoadImageDataTask(completion)
        store.retrieve(dataForUrl: url) { [weak self] result in
            guard self != nil else { return }
            task.complete(with: result
                        .mapError { _ in LoadError.failed }
                        .flatMap { data in data.map { .success($0) } ?? .failure(LoadError.notFound) })
        }
        return task
    }
}

extension LocalFeedImageDataLoader {
    public typealias SaveResult = Result<Void, Swift.Error>
    
    public enum SaveError: Swift.Error {
        case failed
    }
    
    public func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(data: data, for: url) { result in
            completion(.failure(SaveError.failed))
        }
    }
}
