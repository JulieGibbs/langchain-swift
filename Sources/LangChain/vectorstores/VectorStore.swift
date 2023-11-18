//
//  File.swift
//  
//
//  Created by 顾艳华 on 2023/6/14.
//

import Foundation

public struct MatchedModel: Encodable, Decodable {
    let content: String?
    let similarity: Float
    let metadata: [String: String]
}
public protocol VectorStore {
    func addText(text: String, metadata: [String: String]) async
    
    func similaritySearch(query: String, k: Int) async -> [MatchedModel]
}

public protocol VectorStoreByUser {
    func addText(text: String, user_id: String, metadata: [String: String]) async
    
    func similaritySearch(query: String, k: Int, user_id: String) async -> [MatchedModel]
}
