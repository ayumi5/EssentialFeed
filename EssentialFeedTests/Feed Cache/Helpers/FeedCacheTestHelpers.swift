//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2022/02/03.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

func uniqueImageFeed() -> (models: [FeedImage], locals:[LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let locals = models.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.imageURL) }
    
    return (models: models, locals: locals)
}

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
    
    var feedCacheMaxAgeInDays: Int {
        return 7
    }
    
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }

    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}

