//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by 宇高あゆみ on 2022/04/27.
//

import Foundation
import XCTest
import EssentialFeed
import EssentialApp

class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase, FeedImageDataLoaderTestCase {
    func test_init_doesNotLoadImageData() {
        let (_, primaryImageLoader, fallbackImageLoader) = makeSUT()
        
        _ = FeedImageDataLoaderWithFallbackComposite(primary: primaryImageLoader, fallback: fallbackImageLoader)
        
        XCTAssertTrue(primaryImageLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the primary loader")
        XCTAssertTrue(fallbackImageLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }
    
    func test_loadImageData_loadsFromPrimaryLoaderFirst() {
        let url = anyURL()
        let (sut, primaryImageLoader, fallbackImageLoader) = makeSUT()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(primaryImageLoader.loadedURLs, [url], "Expected to load URL from primary loader")
        XCTAssertTrue(fallbackImageLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }
    
    func test_loadImageData_loadsFromFallbackLoaderOnPrimaryLoadFailure() {
        let url = anyURL()
        let (sut, primaryImageLoader, fallbackImageLoader) = makeSUT()
        
        _ = sut.loadImageData(from: url) { _ in }
        primaryImageLoader.complete(with: anyNSError())
        
        XCTAssertEqual(primaryImageLoader.loadedURLs, [url], "Expected to load URL from primary loader")
        XCTAssertEqual(fallbackImageLoader.loadedURLs, [url], "Expected to load URL from fallback loader")
    }
    
    func test_cancelImageData_cancelsPrimaryLoaderTask() {
        let url = anyURL()
        let (sut, primaryImageLoader, fallbackImageLoader) = makeSUT()
        
        let task = sut.loadImageData(from: url) { _ in }
        task.cancel()
        
        XCTAssertEqual(primaryImageLoader.cancelledURLs, [url], "Expected to cancel URL loading from primary loader")
        XCTAssertTrue(fallbackImageLoader.cancelledURLs.isEmpty, "Expected no cancelled URLs in the fallback loader")
    }
    
    func test_cancelImageData_cancelsFallbackLoaderTaskAfterPrimaryLoaderFailure() {
        let url = anyURL()
        let (sut, primaryImageLoader, fallbackImageLoader) = makeSUT()
        
        let task = sut.loadImageData(from: url) { _ in }
        primaryImageLoader.complete(with: anyNSError())
        task.cancel()
        
        XCTAssertTrue(primaryImageLoader.cancelledURLs.isEmpty, "Expected no cancelled URLs in the primary loader")
        XCTAssertEqual(fallbackImageLoader.cancelledURLs, [url], "Expected to cancel URL loading from fallback loader")
    }
    
    func test_loadImageData_deliversPrimaryImageDataOnPrimaryLoaderSuccess() {
        let (sut, primaryImageLoader, _) = makeSUT()
        let primaryImageData = anyData()
        
        expect(sut, toCompleteWith: .success(primaryImageData), when: {
            primaryImageLoader.complete(with: primaryImageData)
        })
    }
    
    func test_loadImageData_deliversFallbackImageDataAfterPrimaryLoaderFailure() {
        let (sut, primaryImageLoader, fallbackImageLoader) = makeSUT()
        let fallbackImageData = anyData()
        
        expect(sut, toCompleteWith: .success(fallbackImageData), when: {
            primaryImageLoader.complete(with: anyNSError())
            fallbackImageLoader.complete(with: fallbackImageData)
        })
    }
    
    func test_loadImageData_deliversErrorOnBothPrimaryAndFallbackLoaderFailure() {
        let (sut, primaryImageLoader, fallbackImageLoader) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(anyNSError()), when: {
            primaryImageLoader.complete(with: anyNSError())
            fallbackImageLoader.complete(with: anyNSError())
        })

    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImageDataLoaderWithFallbackComposite, primary: FeedImageDataLoaderSpy, fallback: FeedImageDataLoaderSpy) {
        let primaryImageLoader = FeedImageDataLoaderSpy()
        let fallbackImageLoader = FeedImageDataLoaderSpy()
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryImageLoader, fallback: fallbackImageLoader)
        trackForMemoryLeaks(primaryImageLoader, file: file, line: line)
        trackForMemoryLeaks(fallbackImageLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, primaryImageLoader, fallbackImageLoader)
    }
}
