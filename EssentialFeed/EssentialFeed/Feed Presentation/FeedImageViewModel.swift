//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/04/14.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public var hasLocation: Bool {
        return location != nil
    }
}
