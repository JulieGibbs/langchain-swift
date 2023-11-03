//
//  File.swift
//  
//
//  Created by 顾艳华 on 2023/11/2.
//
import AsyncHTTPClient
import Foundation
import SwiftyJSON
import NIOPosix

struct WikipediaAPIWrapper {
    func search(query: String) async throws -> [WikipediaPage] {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let httpClient = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
        defer {
            // it's important to shutdown the httpClient after all requests are done, even if one failed. See: https://github.com/swift-server/async-http-client
            try? httpClient.syncShutdown()
        }
        
        let baseURL = "http://en.wikipedia.org/w/api.php"
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "srlimit", value: "10"),
            URLQueryItem(name: "srsearch", value: query),
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "format", value: "json"),
        ]
        print(components.url!.absoluteString)
        var request = HTTPClientRequest(url: components.url!.absoluteString)
        request.method = .GET
        
        let response = try await httpClient.execute(request, timeout: .seconds(30))
        if response.status == .ok {
            let str = String(buffer: try await response.body.collect(upTo: 1024 * 1024))
            let json = try JSON(data: str.data(using: .utf8)!)
            var wikis: [WikipediaPage] = []
            let searchResults = json["qyery"]["search"].arrayValue
            
            for wiki in searchResults {
                wikis.append(WikipediaPage(title: wiki["title"].stringValue, pageid: wiki["pageid"].intValue))
            }
            return wikis
        } else {
            // handle remote error
            print("http code is not 200.")
            return []
        }
    }
}
