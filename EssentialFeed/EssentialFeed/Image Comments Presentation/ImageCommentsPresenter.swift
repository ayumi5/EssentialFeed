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

public struct ImageCommentViewModel: Hashable {
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
    
    public static func map(
        _ comments: [ImageComment],
        currentDate: Date = Date(),
        calendar: Calendar = .current,
        locale: Locale = .current)
    -> ImageCommentsViewModel {
        let formatter = RelativeDateTimeFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        
        return ImageCommentsViewModel(comments: comments.map { comment in
            ImageCommentViewModel(
                message: comment.message,
                date: formatter.localizedString(for: comment.cratedAt, relativeTo: currentDate),
                username: comment.username)
        })
    }
}
