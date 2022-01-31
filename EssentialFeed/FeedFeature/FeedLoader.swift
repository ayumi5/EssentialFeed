//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2021/12/20.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
