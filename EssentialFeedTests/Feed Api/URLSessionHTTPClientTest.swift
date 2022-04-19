//
//  URLSessionHTTPClientTest.swift
//  EssentialFeedTests
//
//  Created by Michael Conchado on 19/04/22.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTest: XCTestCase {
    
    func test_getFromURL_resumeDataTaskWithURL() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url) { _ in }
        
        XCTAssertEqual(task.resumeCallCounts, 1)
    }
    
    func test_getFromURL_failsOnRequestErrors() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let error = NSError(domain: "Any error", code: 1)
        session.stub(url: url, error: error)
        
        let sut = URLSessionHTTPClient(session: session)
        let exp = expectation(description: "wait for completion")
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("expected failure with \(error), got \(result) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: Helpers
    private class URLSessionSpy: URLSession {
        private var stubs = [URL: Stub]()
        
        struct Stub {
            var task: URLSessionDataTask
            var error: Error?
        }
        
        func stub(
            url: URL,
            task: URLSessionDataTask = FakeURLSessionDataTask(),
            error: Error? = nil
        ) {
            stubs[url] = Stub(task: task, error: error)
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            guard let stub = stubs[url] else {
                fatalError("Couldn't find stub for \(url) ")
            }
            completionHandler(nil, nil, stub.error)
            
            return stub.task
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {
        override func resume() {}
    }
    private class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCallCounts = 0
        
        override func resume() {
            resumeCallCounts += 1
        }
    }
}
