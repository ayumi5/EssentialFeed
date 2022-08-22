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
    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }
    var loadError: String {
        LoadResourcePresenter<Any, DummyView>.loadError
    }
    
    var feedTitle: String {
        FeedPresenter.title
    }
}
