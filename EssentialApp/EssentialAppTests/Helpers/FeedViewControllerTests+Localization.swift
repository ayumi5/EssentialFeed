//
//  FeedViewControllerTests+Localization.swift
//  EssentialFeediOSTests
//
//  Created by 宇高あゆみ on 2022/04/07.
//

import Foundation
import XCTest
import EssentialFeed

extension FeedUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key)")
        }
        return value
    }
}
