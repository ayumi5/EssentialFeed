//
//  LoadFeedImageDataFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2022/04/20.
//

import XCTest
import EssentialFeed

class FeedImageDataMapperTests: XCTestCase {
    
    func test_mapImageData_throwsInvalidDataErrorOnNon200HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]
        try samples.forEach { code in
            XCTAssertThrowsError(
            _ = try FeedImageDataMapper.map(anyData(), response: HTTPURLResponse.init(statusCode: code))
            )
        }
    }
    
    func test_mapImageData_throwsInvalidDataErrorOn200HTTPResponseWithEmptyData() {
        let emptyData = Data()
        
        XCTAssertThrowsError(
            _ = try FeedImageDataMapper.map(emptyData, response: HTTPURLResponse.init(statusCode: 200))
        )
    }
    
    func test_mapImageData_deliversReceivedNonEmptyDataOn200HTTPResponse() throws {
        let nonEmptyData = Data("non-empty data".utf8)
        
        let result = try FeedImageDataMapper.map(nonEmptyData, response: HTTPURLResponse(statusCode: 200))
        XCTAssertEqual(result, nonEmptyData)
    }
}
