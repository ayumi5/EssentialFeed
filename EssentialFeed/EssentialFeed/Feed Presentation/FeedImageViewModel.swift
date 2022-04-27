//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/04/14.
//

import Foundation

public struct FeedImageViewModel<Image> {
    public let description: String?
    public let location: String?
    public let image: Image?
    public let isLoading: Bool
    public let shouldRetry: Bool
    
    public var hasLocation: Bool {
        return location != nil
    }
}
