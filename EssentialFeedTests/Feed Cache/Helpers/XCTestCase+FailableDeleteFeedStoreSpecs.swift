//
//  XCTestCase+FailableDeleteFeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2022/02/11.
//

import XCTest
import EssentialFeed

extension FailableDeleteFeedStoreSpecs where Self: XCTestCase {
    
    func assertThatDeleteDeliversErrorOnDeletionError(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        let feed = uniqueImageFeed().locals
        let timestamp = Date()
        insert((feed, timestamp), to: sut)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
}
