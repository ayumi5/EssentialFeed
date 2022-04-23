//
//  LoadFeedImageDataFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2022/04/21.
//

import Foundation
import XCTest
import EssentialFeed

class LoadFeedImageDataFromCacheUseCaseTests: XCTestCase {
    func test_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_loadFeedImageDataFromURL_requestsStoredDataForURL() {
        let (sut, store) = makeSUT()
        let url = URL(string: "http://a-given-url.com")!
        
        _ = sut.loadImageData(from: url) { _ in }
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataUrl: url)])
    }
    
    func test_loadFeedImageDataFromURL_failsOnStoreError() {
        let (sut, store) = makeSUT()
        expect(sut, toCompleteWith: failed(), when: {
            let retrievalError = anyNSError()
            store.complete(with: retrievalError)
        })
    }
    
    func test_loadFeedImageDataFromURL_deliverNotFoundErrorOnEmptyCache() {
        let (sut, store) = makeSUT()
        expect(sut, toCompleteWith: notFound(), when: {
            store.complete(with: .none)
        })
    }
    
    func test_loadFeedImageDataFromURL_deliversStoredDataForURLOnNonFoundData() {
        let (sut, store) = makeSUT()
        let foundData = anyData()
        
        expect(sut, toCompleteWith: .success(foundData), when: {
            store.complete(with: foundData)
        })
    }
    
    func test_loadFeedImageDataFromURL_doesNotDeliverResultAfterCancellingTask() {
        let(sut, store) = makeSUT()
        var receivedResults = [FeedImageDataLoader.Result]()
        let foundData = anyData()
        
        let task = sut.loadImageData(from: anyURL()) { receivedResults.append($0)}
        task.cancel()
        
        store.complete(with: foundData)
        store.complete(with: .none)
        store.complete(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty, "Expected no received results after cancelling task")
        
    }
    
    func test_loadFeedImageDataFromURL_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = StoreSpy()
        var sut: LocalFeedImageDataLoader? = LocalFeedImageDataLoader(store: store)
        var receivedResults = [FeedImageDataLoader.Result]()
        
        _ = sut?.loadImageData(from: anyURL()) { receivedResults.append($0)}
        sut = nil
        store.complete(with: .none)
        
        XCTAssertTrue(receivedResults.isEmpty, "Expected no received results after instance has been deallocated")
    }
    
    func test_saveFeedImageDataForURL_requestsImageDataInsertionForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        let data = anyData()
        
        sut.save(data, for: url) { _ in }
        XCTAssertEqual(store.receivedMessages, [.insert(data: data, for: url)])
    }
    
    // MARK: - Helper
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    private func failed() -> FeedImageDataLoader.Result {
        return .failure(LocalFeedImageDataLoader.Error.failed)
    }
    
    private func notFound() -> FeedImageDataLoader.Result {
        return .failure(LocalFeedImageDataLoader.Error.notFound)
    }
    
    private func expect(_ sut: LocalFeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        _ = sut.loadImageData(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private class StoreSpy: FeedImageDataStore {
        enum Message: Equatable {
            case retrieve(dataUrl: URL)
            case insert(data: Data, for: URL)
        }
        var receivedMessages = [Message]()
        private var completions = [(FeedImageDataStore.Result) -> Void]()
        
        func retrieve(dataForUrl url: URL, completion: @escaping (FeedImageDataStore.Result) -> Void) {
            receivedMessages.append(.retrieve(dataUrl: url))
            completions.append(completion)
        }
        
        func insert(data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
            receivedMessages.append(.insert(data: data, for: url))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            completions[index](.failure(error))
        }
        
        func complete(with data: Data?, at index: Int = 0) {
            completions[index](.success(data))
        }
    }
}
