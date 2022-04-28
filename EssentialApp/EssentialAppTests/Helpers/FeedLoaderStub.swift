//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by 宇高あゆみ on 2022/04/28.
//

import EssentialFeed

class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result
    
    init(_ result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
