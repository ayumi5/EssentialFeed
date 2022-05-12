//
//  FeedAcceptanceTests.swift
//  EssentialAppTests
//
//  Created by 宇高あゆみ on 2022/05/11.
//

import XCTest
import EssentialFeed
import EssentialFeediOS
@testable import EssentialApp
import CloudKit


class FeedAcceptanceTests: XCTestCase {
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let feed = launch(httpClient: .online(stub: response), store: .empty)
        
        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 2)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), makeImageFeed())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), makeImageFeed())
    }
    
    func test_onLaunch_displaysCachedRemoteFeedWhenCustomerHasNoConnectivity() {
        let sharedStore = InMemoryFeedStore.empty
        let online = launch(httpClient: .online(stub: response), store: sharedStore)
        online.simulateFeedImageViewVisible(at: 0)
        online.simulateFeedImageViewVisible(at: 1)
        
        let offlineFeed = launch(httpClient: .offline, store: sharedStore)
        XCTAssertEqual(offlineFeed.numberOfRenderedFeedImageViews(), 2)
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 0), makeImageFeed())
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 1), makeImageFeed())
    }
    
    func test_onLaunch_displaysEmptyFeedWhenCustomerHasNoConnectivityAndNoCache() {
    }
    
    // MARK: - Helpers
    private func launch(httpClient: HTTPClientStub = .offline, store: InMemoryFeedStore = .empty) -> FeedViewController {
        let sut = SceneDelegate(httpClient: httpClient, store: store)
        sut.window = UIWindow()
        
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as! UINavigationController
        return nav.topViewController as! FeedViewController
    }
    
    private class HTTPClientStub: HTTPClient {
        private struct Task: HTTPClientTask {
            func cancel() {}
        }
        
        private let stub: (URL) -> HTTPClient.Result
        
        init(stub: @escaping (URL) -> HTTPClient.Result) {
            self.stub = stub
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            completion(stub(url))
            return Task()
        }
        
        static var offline: HTTPClientStub {
            HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0)) })
        }
        
        static func online(stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
            HTTPClientStub(stub: { url in .success(stub(url)) })
        }
    }
    
    private class InMemoryFeedStore: FeedStore, FeedImageDataStore {
        var feedCache: CachedFeed?
        var feedImageDataCache: [URL:Data] = [:]
        
        func deleteCachedFeed(completion: @escaping FeedStore.DeletionCompletion) {
            feedCache = nil
            completion(.success(()))
        }
        
        func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
            feedCache = CachedFeed(feed: feed, timestamp: timestamp)
            completion(.success(()))
        }
        
        func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
            completion(.success(feedCache))
        }
        
        func retrieve(dataForUrl url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
            completion(.success(feedImageDataCache[url]))
        }
        
        func insert(data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
            feedImageDataCache[url] = data
            completion(.success(()))
        }
        
        static var empty: InMemoryFeedStore {
            InMemoryFeedStore()
        }
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }
    
    private func makeData(for url: URL) -> Data {
        switch url.absoluteString {
        case "https://image.com":
            return makeImageFeed()
        default:
            return makeFeedData()
        }
    }

    private func makeImageFeed() -> Data {
        UIImage.make(withColor: .red).pngData()!
    }

    private func makeFeedData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": UUID().uuidString, "image": "https://image.com"],
            ["id": UUID().uuidString, "image": "https://image.com"]
        ]])
    }
    
}
