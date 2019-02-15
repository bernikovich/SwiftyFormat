//
//  Created by Tsimur Bernikovich on 2/15/19.
//  Copyright © 2019 Tsimur Bernikovich. All rights reserved.
//

import XCTest
@testable import SwiftyFormat

class URLRequestFormatterTests: XCTestCase {
  
  private let url = URL(string: "http://github.com")!
  private var formatter = URLRequestFormatter()
  
  override func setUp() {
    formatter = URLRequestFormatter()
    
    let cookieStorage = HTTPCookieStorage.shared
    if let cookies = cookieStorage.cookies(for: url) {
      cookies.forEach {
        cookieStorage.deleteCookie($0)
      }
    }
  }
  
  func testURLRequestDescriptionURL() {
    let request = URLRequest(url: url)
    let string = formatter.string(from: request)
    XCTAssert(string.contains(url.absoluteString), "URLRequest description should contain method")
  }
  
  func testURLRequestDescriptionMethod() {
    let method = "POST"
    var request = URLRequest(url: url)
    request.httpMethod = method
    let string = formatter.string(from: request)
    XCTAssert(string.contains(method), "URLRequest description should contain url")
  }
  
  func testCURLCompression() {
    let method = "POST"
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
    let command = URLRequestFormatter.curlCommand(from: request)
    XCTAssert(command.contains("--compressed"), "curl should have --compressed parameter when Accept-Encoding contains gzip")
  }
  
  func testJSONBody() {
    let method = "POST"
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
    request.httpBody = try? JSONSerialization.data(withJSONObject: ["some": "value"], options: [])
    let command = URLRequestFormatter.curlCommand(from: request)
    XCTAssert(command.contains("-d \"{\\\"some\\\":\\\"value\\\"}\""), "curl encodes json incorrectly")
  }
  
}
