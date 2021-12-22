//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2021/12/22.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL = URL(string: "https://a-url.com")!, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load() {
        client.get(from: url)
    }
}
