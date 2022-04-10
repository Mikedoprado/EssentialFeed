//
//  RemoteFeedLoaderTest.swift
//  EssentialFeedTests
//
//  Created by Michael Conchado on 10/04/22.
//

import XCTest

class RemoteFeedLoader {
    
    private let client: HTTPClient
    
    func load() {
        client.get(from: URL(string: "http;//a-url.com")!)
    }
    
    init(client: HTTPClient) {
        self.client = client
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    func get(from url: URL) {
        requestedURL = url
    }
}

class RemoteFeedLoaderTest: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(client: client)
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)
        
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }
}
