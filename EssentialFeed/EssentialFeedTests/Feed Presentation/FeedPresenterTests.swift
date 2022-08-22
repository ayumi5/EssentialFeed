//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2022/04/13.
//

import XCTest
import EssentialFeed

class FeedPresenterTests: XCTestCase {
    func test_title_isLocalized() {
        XCTAssertEqual(FeedPresenter.title, localized("FEED_VIEW_TITLE"))
    }
    
    func test_map_createsViewModel() {
        let feed = uniqueImageFeed().models
        let viewModel = FeedPresenter.map(feed)
        XCTAssertEqual(viewModel.feed, feed)
    }
    
    // MARK: - Helpers
    private func localized(_ key: String, table: String = "Feed", file: StaticString = #file, line: UInt = #line) -> String {
        let bundle = Bundle(for: FeedPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key)")
        }
        return value
    }
}
