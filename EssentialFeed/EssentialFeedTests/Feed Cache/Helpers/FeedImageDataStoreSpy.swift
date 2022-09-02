//
//  FeedImageDataStoreSpy.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2022/04/23.
//

import EssentialFeed

class FeedImageDataStoreSpy: FeedImageDataStore {
    enum Message: Equatable {
        case retrieve(dataUrl: URL)
        case insert(data: Data, for: URL)
    }
    var receivedMessages = [Message]()
    private var retrievalCompletions = [(FeedImageDataStore.RetrievalResult) -> Void]()
    private var insertionResult: Result<Void, Error>?
    
    func retrieve(dataForUrl url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        receivedMessages.append(.retrieve(dataUrl: url))
        retrievalCompletions.append(completion)
    }
    
    func insert(data: Data, for url: URL) throws {
        receivedMessages.append(.insert(data: data, for: url))
        try insertionResult?.get()
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retrievalCompletions[index](.success(data))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }
}
