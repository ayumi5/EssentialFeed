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
        let viewModel = FeedImagePresenter<ViewSpy, AnyImage>.map(feedImage)
        XCTAssertEqual(viewModel.description, feedImage.description)
        XCTAssertEqual(viewModel.location, feedImage.location)
    }
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    func test_didStartLoadingImageData_displaysLoadingImage() {
        let (sut, view) = makeSUT()
        let feedImage = uniqueImage()
        
        sut.didStartLoadingImageData(for: feedImage)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, feedImage.description)
        XCTAssertEqual(message?.location, feedImage.location)
        XCTAssertNil(message?.image)
        XCTAssertEqual(message?.isLoading, true)
        XCTAssertEqual(message?.shouldRetry, false)
    }
    
    func test_didFinishLoadingImage_displaysRetryOnFailedImageTransformation() {
        let (sut, view) = makeSUT(imageTansformer: fail)
        let feedImage = uniqueImage()
        
        sut.didFinishLoadingImageData(with: Data(), for: feedImage)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, feedImage.description)
        XCTAssertEqual(message?.location, feedImage.location)
        XCTAssertNil(message?.image)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, true)
    }
    
    func test_didFinishLoadingImage_displaysImageOnSuccessfulImageTransformation() {
        let transformedData = AnyImage()
        let feedImage = uniqueImage()
        let (sut, view) = makeSUT(imageTansformer: { _ in transformedData })
        
        sut.didFinishLoadingImageData(with:  Data(), for: feedImage)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, feedImage.description)
        XCTAssertEqual(message?.location, feedImage.location)
        XCTAssertEqual(message?.image, transformedData)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, false)
    }
    
    func test_didFinishLoadingImageWithError_displaysRetry() {
        let (sut, view) = makeSUT()
        let feedImage = uniqueImage()
        
        sut.didFinishLoadingImageData(with: anyNSError(), for: feedImage)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, feedImage.description)
        XCTAssertEqual(message?.location, feedImage.location)
        XCTAssertNil(message?.image)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, true)
    }
    
    // MARK: - Helpers
    private func makeSUT(imageTansformer: @escaping (Data) -> AnyImage? = { _ in nil }, file: StaticString = #file, line: UInt = #line) -> (sut: FeedImagePresenter<ViewSpy, AnyImage>, view: ViewSpy){
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view, imageTransformer: imageTansformer)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(view, file: file, line: line)
        
        return (sut, view)
    }
    
    private var fail: ((Data) -> AnyImage?) {
        return { _ in nil }
    }
    
    private struct AnyImage: Equatable {}
    
    private class ViewSpy: FeedImageView {
        var messages = [FeedImageViewModel<AnyImage>]()
        
        func display(_ model: FeedImageViewModel<AnyImage>) {
            messages.append(model)
        }
    }
    
}
