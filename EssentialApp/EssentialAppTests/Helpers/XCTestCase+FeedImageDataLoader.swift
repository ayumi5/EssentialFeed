//
//  XCTestCase+FeedImageDataLoader.swift
//  EssentialAppTests
//
//  Created by 宇高あゆみ on 2022/04/28.
//

import XCTest
import EssentialFeed

protocol FeedImageDataLoaderTestCase: XCTestCase {}

extension FeedImageDataLoaderTestCase {
    func expect(_ sut: FeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        _ = sut.loadImageData(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            case (.failure, .failure): break
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
}
