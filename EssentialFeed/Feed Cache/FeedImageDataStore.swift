//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/04/23.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    typealias InsertionResult = Swift.Result<Void, Error>
    
    func retrieve(dataForUrl url: URL, completion: @escaping (Result) -> Void)
    func insert(data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
}
