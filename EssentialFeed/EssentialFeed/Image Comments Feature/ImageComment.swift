//
//  ImageComment.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/08/11.
//

import Foundation

public struct ImageComment: Equatable {
    public let id: UUID
    public let message: String
    public let cratedAt: Date
    public let username: String
    
    public init(id: UUID, message: String, createdAt: Date, username: String) {
        self.id = id
        self.message = message
        self.cratedAt = createdAt
        self.username = username
    }
}
