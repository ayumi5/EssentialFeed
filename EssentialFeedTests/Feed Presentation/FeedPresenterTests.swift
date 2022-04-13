//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2022/04/13.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
}

class FeedPresenterTests: XCTest {
    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()
        let _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    // MARK: - Helpers
    private class ViewSpy {
        let messages = [Any]()
    }
}
