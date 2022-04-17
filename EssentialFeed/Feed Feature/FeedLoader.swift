//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Michael Conchado on 10/04/22.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
