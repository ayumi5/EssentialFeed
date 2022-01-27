//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2022/01/27.
//

import XCTest

class FeedStore {
    var deleteCachedFeedCallCount = 0
}


class LocalFeedLoader {
    private let store: FeedStore
    init(store: FeedStore) {
        self.store = store
    }
}

class CacheFeedUseCaseTests: XCTestCase {
    func test_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
    
    
}
