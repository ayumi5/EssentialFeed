//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by 宇高あゆみ on 2022/03/28.
//

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}
