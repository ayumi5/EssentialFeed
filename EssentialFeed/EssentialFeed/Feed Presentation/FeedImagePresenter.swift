//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/04/14.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
            description: image.description,
            location: image.location)
    }
}
