//
//  CommentsUIIntegrationTests.swift
//  EssentialAppTests
//
//  Created by 宇高あゆみ on 2022/08/26.
//

import XCTest
import EssentialApp
import EssentialFeed
import EssentialFeediOS

class CommentsUIIntegrationTests: FeedUIIntegrationTests {
    override func test_feedView_hasTitle() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
       XCTAssertEqual(sut.title, feedTitle)
    }
    
    override func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadFeedCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadFeedCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadFeedCallCount, 2, "Expected another loading request once user initiates a load")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadFeedCallCount, 3, "Expected a third loading request once user initiates another load")
    }
    
    override func test_loadingFeedIndicator_isVisibleWhileLoadingFeedb() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "Expected loading indicator once view is loaded")
        
        loader.completeFeedLoading(at: 0)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "Expected no loading indicator once loading completes successfully")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "Expected loading indicator once initiates a reload")
        
        loader.completeFeedLoadingWithError(at: 1)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "Expected no loading indicator once user initiated loading completes with error")
    }
    
    override func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
        let image0 = makeImage(description: "a description", location: "a location")
        let image1 = makeImage(description: nil, location: "a location")
        let image2 = makeImage(description: "a description", location: nil)
        let image3 = makeImage(description: nil, location: nil)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeFeedLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoading(with: [image0, image1, image2, image3], at: 1)
        assertThat(sut, isRendering: [image0, image1, image2, image3])
    }
    
    override func test_loadFeedCompletion_rendersSuccessfullyLoadedEmptyFeedAfterNonEmptyFeed() {
        let image0 = makeImage()
        let image1 = makeImage()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeFeedLoading(with: [image0, image1], at: 0)
        assertThat(sut, isRendering: [image0, image1])
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoading(with: [], at: 1)
        assertThat(sut, isRendering: [])
    }
    
    override func test_loadFeedCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let image0 = makeImage()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoadingWithError(at: 1)
        assertThat(sut, isRendering: [image0])
    }
    
    override func test_errorView_rendersErrorMessageOnErrorUntilNextReload() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.errorMessage, nil)
        
        loader.completeFeedLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    override func test_tapOnErrorView_hidesErrorMessage() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.errorMessage, nil)
        
        loader.completeFeedLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)
        
        sut.simulateErrorViewTap()
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    override func test_loadFeedCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeFeedLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: ListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = CommentsUIComposer.commentsComposedWith(
            commentsLoader: loader.loadPublisher)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    
    private func makeImage(description: String? = nil, location: String? = nil, url: URL = URL(string: "http://any-url.com")!) -> FeedImage {
        return FeedImage(id: UUID(), description: description, location: location, url: url)
    }
}
