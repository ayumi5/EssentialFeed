//
//  ImageCommentMapperTests.swift
//  EssentialFeedTests
//
//  Created by 宇高あゆみ on 2022/08/11.
//

import XCTest
import EssentialFeed

class ImageCommentMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon2xxHTTPResponse() throws {
        let json = makeItemsJson([])
        
        let samples = [199, 150, 300, 400, 500]
        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn2xxHTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("invalid json".utf8)
        
        let samples = [200, 201, 250, 280, 299]
        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJson([])
        
        let samples = [200, 201, 250, 280, 299]
        try samples.forEach { code in
            let result = try ImageCommentMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: code))
            XCTAssertEqual(result, [])
        }
    }
    
    func test_map_deliversItemsOn2xxHTTPResponseWithJSONList() throws {
        let item1 = makeItem(id: UUID(),
                             message: "a message",
                             createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"),
                             username: "a username")
        let item2 = makeItem(id: UUID(),
                             message: "another message",
                             createdAt: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"),
                             username: "another username")
        
        let items = [item1.model, item2.model]
        let json = makeItemsJson([item1.json, item2.json])
        
        let samples = [200, 201, 250, 280, 299]
        try samples.forEach { code in
            let result = try ImageCommentMapper.map(json, from: HTTPURLResponse(statusCode: code))
            XCTAssertEqual(result, items)
        }
    }
    
    // MARK: - Helpers
    func makeItem(id: UUID, message: String, createdAt: (date: Date, iso860String: String), username: String) -> (model: ImageComment, json: [String: Any]) {
        let item = ImageComment(id: id, message: message, createdAt: createdAt.date, username: username)
        let json: [String:Any] = [
            "id": id.uuidString,
            "message": message,
            "created_at": createdAt.iso860String,
            "author": [
                "username": username
            ]
        ]
        
        return (model: item, json: json)
    }
}
