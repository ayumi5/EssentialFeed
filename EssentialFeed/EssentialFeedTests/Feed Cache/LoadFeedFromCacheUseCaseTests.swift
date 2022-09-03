//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2022/02/02.
//

import XCTest
import EssentialFeed

class LoadFeedFromCacheUseCaseTests: XCTestCase {

    func test_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        _ = try? sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        expect(sut, completeWithResult: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }
    
    func test_load_deliversNoImagesOnEmptyCache() {
        let (sut, store) = makeSUT()
        expect(sut, completeWithResult: .success([]), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }
    
    func test_load_deliversCachedImagesOnNonExpiredCache() {
        let fixedCurrentDate = Date()
        let feed = uniqueImageFeed()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        expect(sut, completeWithResult: .success(feed.models), when: {
            store.complete(with: feed.locals, timestamp: nonExpiredTimestamp)
        })
    }
    
    func test_load_deliversNoImagesOnCacheExpiration() {
        let fixedCurrentDate = Date()
        let feed = uniqueImageFeed()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        expect(sut, completeWithResult: .success([]), when: {
            store.complete(with: feed.locals, timestamp: expiredTimestamp)
        })
    }
    
    func test_load_deliversNoImagesOnExpiredCache() {
        let fixedCurrentDate = Date()
        let feed = uniqueImageFeed()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        expect(sut, completeWithResult: .success([]), when: {
            store.complete(with: feed.locals, timestamp: expiredTimestamp)
        })
    }
    
    func test_load_hasNoSideEffectsOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        store.completeRetrieval(with: anyNSError())
        _ = try? sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        store.completeRetrievalWithEmptyCache()
        _ = try? sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnNonExpiredCache() {
        let fixedCurrentDate = Date()
        let feed = uniqueImageFeed()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        store.complete(with: feed.locals, timestamp: nonExpiredTimestamp)
        _ = try? sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnCacheExpiration() {
        let fixedCurrentDate = Date()
        let feed = uniqueImageFeed()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        store.complete(with: feed.locals, timestamp: expiredTimestamp)
        _ = try? sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnExpiredCache() {
        let fixedCurrentDate = Date()
        let feed = uniqueImageFeed()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        store.complete(with: feed.locals, timestamp: expiredTimestamp)
        _ = try? sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut: sut, store: store)
    }
    
    func expect(_ sut: LocalFeedLoader, completeWithResult expectedResult: Swift.Result<[FeedImage], Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        action()
        
        let receivedResult = Result { try sut.load() }
        switch (receivedResult, expectedResult) {
        case (let .success(receivedImages), let .success(expectedImages)):
            XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)
        case (let .failure(receivedError as NSError), let .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        default:
            XCTFail("Expected to get \(expectedResult), got \(receivedResult) instead")
        }
    }
}
