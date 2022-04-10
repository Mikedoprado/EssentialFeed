//
//  RemoteFeedLoaderTest.swift
//  EssentialFeedTests
//
//  Created by Michael Conchado on 10/04/22.
//

import XCTest

class RemoteFeedLoader {
    
    let client: HTTPClient
    let url: URL
    func load() {
        client.get(from: url)
    }
    
    init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
}

protocol HTTPClient {
    func get(from url: URL)
}


class RemoteFeedLoaderTest: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "http;//a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK: Helpers
    private func makeSUT(url: URL = URL(string: "http;//a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
    }

}
