//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2021/12/20.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
