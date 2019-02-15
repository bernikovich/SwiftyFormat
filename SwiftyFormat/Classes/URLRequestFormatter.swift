//
//  Created by Tsimur Bernikovich on 2/15/19.
//  Copyright © 2019 Tsimur Bernikovich. All rights reserved.
//

import Foundation

class URLRequestFormatter: Formatter {
  
  private static let defaultHTTPMethod = "GET"
  
  func string(from request: URLRequest) -> String {
    return "\(request.httpMethod ?? URLRequestFormatter.defaultHTTPMethod) \(request.url?.absoluteString ?? "")"
  }
  
  static func curlCommand(from request: URLRequest) -> String {
    var command = "curl"
    
    command.appendCommandLineArgument("-X \(request.httpMethod ?? defaultHTTPMethod)")
    
    // The best "documentation" I found for now:
    // https://unix.stackexchange.com/a/296147
    if let body = request.httpBody, !body.isEmpty {
      var httpBodyString = String(data: body, encoding: .utf8) ?? ""
      httpBodyString = httpBodyString.replacingOccurrences(of: "\\", with: "\\\\")
      httpBodyString = httpBodyString.replacingOccurrences(of: "`", with: "\\`")
      httpBodyString = httpBodyString.replacingOccurrences(of: "\"", with: "\\\"")
      httpBodyString = httpBodyString.replacingOccurrences(of: "$", with: "\\$")
      command.appendCommandLineArgument("-d \"\(httpBodyString)\"")
    }
    
    if request.allHTTPHeaderFields?["Accept-Encoding"]?.contains("gzip") ?? false {
      command.appendCommandLineArgument("--compressed")
    }
    
    if let url = request.url {
      if let cookies = HTTPCookieStorage.shared.cookies(for: url), !cookies.isEmpty {
        let cookieString = cookies.map({ "\($0.name)=\($0.value);" }).joined()
        command.appendCommandLineArgument("--cookie \"\(cookieString)\"")
      }
    }
    
    request.allHTTPHeaderFields?.forEach {
      command.appendCommandLineArgument("-H '\($0.key): \($0.value.replacingOccurrences(of: "\\", with: "\\\\"))'")
    }
    
    command.appendCommandLineArgument(request.url?.absoluteString ?? "")
    return command
  }
  
  static func wgetCommand(from request: URLRequest) -> String {
    guard request.httpMethod == "GET" || request.httpMethod == "POST" else {
      fatalError("Invalid HTTP method, wget can only make GET and POST requests")
    }
    
    var command = "wget"
    
    if let body = request.httpBody, !body.isEmpty {
      let bodyString = String(data: body, encoding: .utf8)
      command.appendCommandLineArgument("-d \(bodyString ?? "")")
    }
    
    request.allHTTPHeaderFields?.forEach {
      command.appendCommandLineArgument("--header='\($0.key): \($0.value.replacingOccurrences(of: "\'", with: "\\\'"))'")
    }
    
    command.appendCommandLineArgument("\"\(request.url?.absoluteString ?? "")\"")
    
    return command
  }
  
  // TODO: Implement other required methods
  // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/DataFormatting/Articles/CreatingACustomFormatter.html
  
}

class HTTPURLResponseFormatter: Formatter {
  
  func string(from response: HTTPURLResponse) -> String {
    return "\(response.statusCode) \(response.url?.absoluteString ?? "")"
  }
  
  override func string(for obj: Any?) -> String? {
    if let response = obj as? HTTPURLResponse {
      return string(from: response)
    }
    return nil
  }
  
}

private extension String {
  
  mutating func appendCommandLineArgument(_ argument: String) {
    append(" \(argument.trimmingCharacters(in: .whitespaces))")
  }
  
}
