//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Michael Conchado on 10/04/22.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
