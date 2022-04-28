//
//  FeedLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by 宇高あゆみ on 2022/04/28.
//

import XCTest
import EssentialFeed

final class FeedLoaderCacheDecorator: FeedLoader {
    private let decoratee: FeedLoader
    init(_ decoratee: FeedLoader) {
        self.decoratee = decoratee
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load(completion: completion)
    }
}

class FeedLoaderCacheDecoratorTests: XCTestCase, FeedLoaderTestCase {
    func test_load_deliversFeedOnLoaderSuccess() {
        let feed = uniqueFeed()
        let loader = FeedLoaderStub(.success(feed))
        let sut = FeedLoaderCacheDecorator(loader)
        
        expect(sut, toCompleteWith: .success(feed))
    }
    
    func test_load_deliversErrorOnLoaderFailure() {
        let loader = FeedLoaderStub(.failure(anyNSError()))
        let sut = FeedLoaderCacheDecorator(loader)
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
}
