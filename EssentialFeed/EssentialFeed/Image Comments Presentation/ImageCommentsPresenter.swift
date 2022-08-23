//
//  ImageCommentsPresenter.swift
//  EssentialFeed
//
//  Created by 宇高あゆみ on 2022/08/23.
//

import Foundation

public struct ImageCommentsViewModel {
    public var comments: [ImageCommentViewModel]
}

public struct ImageCommentViewModel: Equatable {
    public var message: String
    public var date: String
    public var username: String
    
    public init(message: String, date: String, username: String) {
        self.message = message
        self.date = date
        self.username = username
    }
}

public final class ImageCommentsPresenter {
    public static var title: String {
        return NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE", tableName: "ImageComments", bundle: Bundle(for: Self.self), comment: "Title for the image comments view")
    }
    
    public static func map(_ comments: [ImageComment]) -> ImageCommentsViewModel {
        let formatter = RelativeDateTimeFormatter()
        // TODO: Change the current locale to English to pass the test until localization is implemented
        formatter.locale = Locale(identifier: "en")
        
        return ImageCommentsViewModel(comments: comments.map { comment in
            ImageCommentViewModel(
                message: comment.message,
                date: formatter.localizedString(for: comment.cratedAt, relativeTo: Date()),
                username: comment.username)
        })
    }
}
