//
//  File.swift
//  
//
//  Created by 顾艳华 on 2023/8/31.
//

import Foundation
import NIOPosix
import AsyncHTTPClient
import OpenAIKit

public class ChatOpenAI: LLM {
    let temperature: Double
    let model: ModelID
    let httpClient: HTTPClient?
    let urlSession: URLSession?
    public init(httpClient: HTTPClient? = nil, urlSession: URLSession? = nil, temperature: Double = 0.0, model: ModelID = Model.GPT3.gpt3_5Turbo16K, callbacks: [BaseCallbackHandler] = [], cache: BaseCache? = nil) {
        self.httpClient = httpClient
        self.urlSession = urlSession
        self.temperature = temperature
        self.model = model
        super.init(callbacks: callbacks, cache: cache)
    }
    public override func _send(text: String, stops: [String] = []) async throws -> LLMResult {
        let env = Env.loadEnv()
        
        if let apiKey = env["OPENAI_API_KEY"] {
            let baseUrl = env["OPENAI_API_BASE"] ?? "api.openai.com"

            let configuration = Configuration(apiKey: apiKey, api: API(scheme: .https, host: baseUrl))

#if os(macOS) || os(iOS) || os(visionOS)
            assert(httpClient != nil, "Http client is not nil")
            let openAIClient = OpenAIKit.Client(httpClient: httpClient!, configuration: configuration)
#else
            assert(urlSession != nil, "URL Session is not nil")
            let openAIClient = OpenAIKit.Client(session: urlSession!, configuration: configuration)
#endif
            let buffer = try await openAIClient.chats.stream(model: model, messages: [.user(content: text)], temperature: temperature)
            return OpenAIResult(generation: buffer)
        } else {
            print("Please set openai api key.")
            return LLMResult()
        }
    }
}
