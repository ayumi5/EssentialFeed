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

        sut.deleteCache()
        store.completeRetrieval(with: anyNSError())
     
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deletionCompletion])
    }
    
    func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.deleteCache()
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_doesNotDeleteCacheOnLessThanSevenDaysOldCache() {
        let fixedCurrentDate = Date()
        let feed = uniqueImageFeed()
        let lessThanSevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        sut.deleteCache()
        store.complete(with: feed.locals, timestamp: lessThanSevenDaysOldTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_deletesCacheOnSevenDaysOldCache() {
        let fixedCurrentDate = Date()
        let feed = uniqueImageFeed()
        let sevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        sut.deleteCache()
        store.complete(with: feed.locals, timestamp: sevenDaysOldTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deletionCompletion])
    }
    
    func test_load_deletesCacheOnMoreThanSevenDaysOldCache() {
        let fixedCurrentDate = Date()
        let feed = uniqueImageFeed()
        let moreThanSevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        sut.deleteCache()
        store.complete(with: feed.locals, timestamp: moreThanSevenDaysOldTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deletionCompletion])
    }
    
    func test_validateCache_doesNotDeleteInvalidCacheAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        sut?.deleteCache()
        sut = nil
        store.completeRetrieval(with: anyNSError())
        
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
}
