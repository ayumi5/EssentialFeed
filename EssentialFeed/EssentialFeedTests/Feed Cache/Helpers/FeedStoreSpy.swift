//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2022/02/02.
//

import Foundation
import EssentialFeed

class FeedStoreSpy: FeedStore {
    var deletionResult: Result<Void, Error>?
    var insertionResult: Result<Void, Error>?
    var retrievalResult: Result<CachedFeed?, Error>?
    
    enum ReceivedMessage: Equatable {
        case deletionCompletion
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    var receivedMessages = [ReceivedMessage]()
    
    func deleteCachedFeed() throws {
        receivedMessages.append(.deletionCompletion)
        try deletionResult?.get()
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionResult = .failure(error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionResult = .success(())
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        receivedMessages.append(.insert(feed, timestamp))
        try insertionResult?.get()
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }
    
    func retrieve() throws -> CachedFeed? {
        receivedMessages.append(.retrieve)
        return try retrievalResult?.get()
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalResult = .success(.none)
    }
    
    func complete(with images: [LocalFeedImage], timestamp: Date, at index: Int = 0) {
        retrievalResult = .success(CachedFeed(feed: images, timestamp: timestamp))
    }
}
