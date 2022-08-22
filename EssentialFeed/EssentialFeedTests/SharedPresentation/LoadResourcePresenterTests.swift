//
//  LoadResourcePresenterTests.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2022/08/22.
//

import XCTest
import EssentialFeed

class LoadResourcePresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    func test_didStartLoading_displayNoErrorMessageAnStartsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoading()
        XCTAssertEqual(view.messages, [.display(errorMessage: .none),
            .display(isLoading: true)])
    }
    
    func test_didFinishLoadingResource_displayResourceAndStopsLoading() {
        let (sut, view) = makeSUT(mapper: { resource in
            resource + " view model"
        })
        let resource = "resource"
        
        sut.didFinishLoading(with: resource)
        XCTAssertEqual(view.messages,
                       [.display(resourceViewModel: "resource view model"),
                        .display(isLoading: false)])
    }
    
    func test_didFinishLoadingFeedWithError_displaysErrorMessageAndStopsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didFinishLoadingFeed(with: anyNSError())
        XCTAssertEqual(view.messages,
                       [.display(errorMessage: localized("FEED_VIEW_CONNECTION_ERROR")),
                        .display(isLoading: false)])
        
    }
    
    // MARK: - Helpers
    private typealias SUT = LoadResourcePresenter<String, ViewSpy>
    
    
    private func makeSUT(
        mapper: @escaping SUT.Mapper = { _ in "any" },
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: SUT, view: ViewSpy) {
        let view = ViewSpy()
        let sut = LoadResourcePresenter(resourceView: view, loadingView: view, errorView: view, mapper: mapper)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, view)
    }
    
    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: SUT.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key)")
        }
        return value
    }
    
    private class ViewSpy: FeedErrorView, FeedLoadingView, ResourceView {
        typealias ResourceViewModel = String
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(resourceViewModel: String)
        }
        
        private(set) var messages = Set<Message>()
        
        func display(_ viewModel: FeedErrorViewModel) {
            messages.insert(Message.display(errorMessage: viewModel.message))
        }
        
        func display(_ viewModel: FeedLoadingViewModel) {
            messages.insert(Message.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: String) {
            messages.insert(Message.display(resourceViewModel: viewModel))
        }
    }

}
