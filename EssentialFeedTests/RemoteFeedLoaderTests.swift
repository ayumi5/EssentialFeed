//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2021/12/20.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.get(url: URL(string: "https://a-url.com")!)
    }
}

class HTTPClient {
    static var shared = HTTPClient()
    
    func get(url: URL) {}
    
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    override func get(url: URL) {
        requestedURL = url
    }
}

class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesnNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
