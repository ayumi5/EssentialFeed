//
//  CoreDataFeedImageDataStoreTests.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2022/04/23.
//

import Foundation
import XCTest
import EssentialFeed

class CoreDataFeedImageDataStoreTests: XCTestCase {
    func test_retrieveImageData_deliversNotFoundErrorOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toCompleteRetrievalWith: notFound())
    }
    
    func test_retrieveImageData_deliversNotFoundErrorWhenStoredDataURLDoesNotMatch() {
        let sut = makeSUT()
        let url = URL(string: "https://a-given-url.com")!
        let nonMatchingURL = URL(string: "https://another-url.com")!
        
        insert(anyData(), for: url, into: sut)
        expect(sut, toCompleteRetrievalWith: notFound(), for: nonMatchingURL)
    }
    
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredDataMatchingURL() {
        let sut = makeSUT()
        let matchingURL = URL(string: "https://a-given-url.com")!
        let storedData = anyData()
        
        insert(storedData, for: matchingURL, into: sut)
        
        expect(sut, toCompleteRetrievalWith: found(storedData), for: matchingURL)
    }
    
    func test_retrieveImageData_deliversLastInsertedValue() {
        let sut = makeSUT()
        let url = URL(string: "http://a-url.com")!
        let firstStoredData = Data("first-stored-data".utf8)
        let lastStoredData = Data("last-stored-data".utf8)
        
        insert(firstStoredData, for: url, into: sut)
        insert(lastStoredData, for: url, into: sut)
        expect(sut, toCompleteRetrievalWith: found(lastStoredData), for: url)
    }
    
    func test_retrieveImageData_runsSerially() {
        let sut = makeSUT()
        let url = anyURL()

        let op1 = expectation(description: "Operation 1")
        sut.insert([localImage(url: url)], timestamp: Date()) { _ in
            op1.fulfill()
        }

        let op2 = expectation(description: "Operation 2")
        sut.insert(data: anyData(), for: url) { _ in
            op2.fulfill()
        }
        let op3 = expectation(description: "Operation 3")
        sut.insert(data: anyData(), for: url) { _ in
            op3.fulfill()
        }
        wait(for: [op1, op2, op3], timeout: 5.0, enforceOrder: true)

    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataFeedStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func notFound() -> FeedImageDataStore.RetrievalResult {
        return .success(.none)
    }
    
    private func found(_ data: Data) -> FeedImageDataStore.RetrievalResult {
        return .success(data)
    }
    
    private func localImage(url: URL) -> LocalFeedImage {
        return LocalFeedImage(id: UUID(), description: "any", location: "any", url: url)
    }
    
    private func expect(_ sut: FeedImageDataStore, toCompleteRetrievalWith expectedResult: FeedImageDataStore.RetrievalResult, for url: URL = anyURL(), file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for retrieal completion")
        
        sut.retrieve(dataForUrl: url) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func insert(_ data: Data, for url: URL, into sut: CoreDataFeedStore, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache insertion")
        let image = localImage(url: url)
        sut.insert([image], timestamp: Date()) { result in
            switch result {
            case let .failure(error):
                XCTFail("Failed to save \(image) with error \(error)", file: file, line: line)
                exp.fulfill()
            case .success:
                sut.insert(data: data, for: url) { result in
                    if case let Result.failure(error) = result {
                        XCTFail("Failed to insert \(data) with error \(error)", file: file, line: line)
                    }
                }
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
