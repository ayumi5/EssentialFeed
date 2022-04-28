//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by 宇高あゆみ on 2022/04/27.
//

import Foundation
import EssentialFeed

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "any", location: "any", url: URL(string: "https://any-url.com")!)]
}
