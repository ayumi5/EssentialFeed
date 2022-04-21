//
//  LoadFeedImageDataFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2022/04/21.
//

import Foundation
import XCTest


final class LocalFeedImageDataLoader {
    init(store: Any) {
        
    }
}

class LoadFeedImageDataFromCacheUseCaseTests: XCTestCase {
    func test_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    // MARK: - Helper
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedImageStoreSpy) {
        let store = FeedImageStoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    private class FeedImageStoreSpy {
        var receivedMessages = [Any]()
    }
}
