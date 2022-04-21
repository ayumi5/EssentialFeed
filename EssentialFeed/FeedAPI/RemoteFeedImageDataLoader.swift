//
//  RemoteFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/04/21.
//

import Foundation

public final class RemoteFeedImageDataLoader: FeedImageDataLoader {
    private let client: HTTPClient
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private final class HTTPClientTaskWrapper: FeedImageDataLoaderTask {
        private var completion: ((FeedImageDataLoader.Result) -> Void)?
        
        var wrapped: HTTPClientTask?
        
        init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletion()
            wrapped?.cancel()
        }
        
        private func preventFurtherCompletion() {
            completion = nil
        }
    }
    
    @discardableResult
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        task.wrapped = client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                guard response.statusCode == 200 && !data.isEmpty else {
                    return task.complete(with: .failure(Error.invalidData))
                }
                task.complete(with: .success(data))
            case .failure: task.complete(with: .failure(Error.connectivity))
            }
        }
        return task
    }
}
