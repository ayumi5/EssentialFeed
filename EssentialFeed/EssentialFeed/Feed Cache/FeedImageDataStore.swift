//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/04/23.
//

import Foundation

public protocol FeedImageDataStore {
    typealias RetrievalResult = Swift.Result<Data?, Error>
    typealias InsertionResult = Swift.Result<Void, Error>
    
    func retrieve(dataForUrl url: URL) throws -> Data?
    func insert(data: Data, for url: URL) throws
    
    @available(*, deprecated)
    func retrieve(dataForUrl url: URL, completion: @escaping (RetrievalResult) -> Void)

    @available(*, deprecated)
    func insert(data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
}

public extension FeedImageDataStore {
    func retrieve(dataForUrl url: URL) throws -> Data? {
        let group = DispatchGroup()
        group.enter()
        var result: RetrievalResult!
        retrieve(dataForUrl: url) {
            result = $0
            group.leave()
        }
        group.wait()
        
        return try result.get()
    }

    func insert(data: Data, for url: URL) throws {
        let group = DispatchGroup()
        group.enter()
        var result: InsertionResult!
        insert(data: data, for: url) {
            result = $0
            group.leave()
        }
        group.wait()
        
        return try result.get()
    }
    
    func retrieve(dataForUrl url: URL, completion: @escaping (RetrievalResult) -> Void) {}

    func insert(data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {}
}
