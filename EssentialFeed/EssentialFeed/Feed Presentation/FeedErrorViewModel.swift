//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/04/13.
//
public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
