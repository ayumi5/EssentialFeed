//
//  FeedImageLoader.swift
//  EssentialFeediOS
//
//  Created by 宇高あゆみ on 2022/03/25.
//

import Foundation

public protocol FeedImageDataLoader {    
    func loadImageData(from url: URL) throws -> Data
}
