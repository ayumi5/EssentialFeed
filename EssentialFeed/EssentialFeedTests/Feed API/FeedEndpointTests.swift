//
//  FeedEndpointTests.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2022/08/29.
//

import XCTest
import EssentialFeed

class FeedEndpointTests: XCTestCase {

    func test_feed_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = FeedEndPoint.get.url(baseURL: baseURL)
        let expected = URL(string: "http://base-url.com/v1/feed")!
        
        XCTAssertEqual(received, expected)
    }
}
