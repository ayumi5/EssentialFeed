//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2022/04/13.
//

import XCTest
import EssentialFeed

class FeedImagePresenterTests: XCTestCase {
    func test_map_createsViewModel() {
        let feedImage = uniqueImage()
        let viewModel = FeedImagePresenter.map(feedImage)
        XCTAssertEqual(viewModel.description, feedImage.description)
        XCTAssertEqual(viewModel.location, feedImage.location)
    }
}
