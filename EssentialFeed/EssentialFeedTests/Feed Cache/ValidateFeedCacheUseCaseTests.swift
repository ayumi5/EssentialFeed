//
//  ValidateFeedCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2022/02/03.
//

import XCTest
import EssentialFeed

class ValidateFeedCacheUseCaseTests: XCTestCase {
    func test_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_validateCache_deletesCacheOnRetrievalError() {
        let (sut, store) = makeSUT()

        store.completeRetrieval(with: anyNSError())
        try? sut.validateCache()
     
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deletionCompletion])
    }
    
    func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        store.completeRetrievalWithEmptyCache()
        try? sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_doesNotDeleteCacheOnNonExpiredCache() {
        let fixedCurrentDate = Date()
        let feed = uniqueImageFeed()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        store.complete(with: feed.locals, timestamp: nonExpiredTimestamp)
        try? sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_deletesCacheOnCacheExpiration() {
        let fixedCurrentDate = Date()
        let feed = uniqueImageFeed()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        store.complete(with: feed.locals, timestamp: expiredTimestamp)
        try? sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deletionCompletion])
    }
    
    func test_load_deletesCacheOnExpiredCache() {
        let fixedCurrentDate = Date()
        let feed = uniqueImageFeed()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        store.complete(with: feed.locals, timestamp: expiredTimestamp)
        try? sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deletionCompletion])
    }
    
    func test_validateCache_failsOnDeletionErrorOfFailedRetrieval() {
        let deletionError = anyNSError()
        let (sut, store) = makeSUT()
       
        expect(sut, toCompleteWith: .failure(deletionError), when: {
            store.completeRetrieval(with: anyNSError())
            store.completeDeletion(with: deletionError)
        })
    }
    
    func test_validateCache_succeedsOnDeletionOfFailedRetrieval() {
        let (sut, store) = makeSUT()
       
        expect(sut, toCompleteWith: .success(()), when: {
            store.completeRetrieval(with: anyNSError())
            store.completeDeletionSuccessfully()
        })
    }
    
    func test_validateCache_succeedsOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success(()), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }
    
    func test_validateCache_succeedsOnNonExpiredCache() {
        let feed = uniqueImageFeed().locals
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        expect(sut, toCompleteWith: .success(()), when: {
            store.complete(with: feed, timestamp: nonExpiredTimestamp)
        })
    }
    
    func test_validateCache_failsOnDeletionErrorOfExpiredCache() {
        let feed = uniqueImageFeed().locals
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        let deletionError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(deletionError), when: {
            store.complete(with: feed, timestamp: expiredTimestamp)
            store.completeDeletion(with: deletionError)
        })
    }
    
    func test_validateCache_succeedsOnSuccessfulDeletionOfExpiredCache() {
        let feed = uniqueImageFeed().locals
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        expect(sut, toCompleteWith: .success(()), when: {
            store.complete(with: feed, timestamp: expiredTimestamp)
            store.completeDeletionSuccessfully()
        })
    }

    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut: sut, store: store)
    }
    
    private func expect(_ sut: LocalFeedLoader, toCompleteWith expectedResult: Result<Void, Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        action()
        
        let receivedResult = Result { try sut.validateCache() }
        switch (receivedResult, expectedResult) {
        case (.success, .success): break
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
