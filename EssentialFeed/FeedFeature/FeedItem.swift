//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2021/12/20.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
