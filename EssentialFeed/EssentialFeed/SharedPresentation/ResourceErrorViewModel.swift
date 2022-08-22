//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/04/13.
//
public struct ResourceErrorViewModel {
    public let message: String?
    
    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
