//
//  File.swift
//  
//
//  Created by 顾艳华 on 2023/6/10.
//

import Foundation

public class LLM {
    static let LLM_REQ_ID_KEY = "llm_req_id"
    static let LLM_COST_KEY = "cost"
    public init(callbacks: [BaseCallbackHandler] = []) {
        self.callbacks = callbacks
    }
    let callbacks: [BaseCallbackHandler]
    
    public func send(text: String, stops: [String] = []) async -> LLMResult {
        let reqId = UUID().uuidString
        var cost = 0.0
        let now = Date.now.timeIntervalSince1970
        callStart(prompt: text, reqId: reqId)
        do {
            let llmResult = try await _send(text: text, stops: stops)
            cost = Date.now.timeIntervalSince1970 - now
            if !llmResult.stream {
                callEnd(output: llmResult.llm_output!, reqId: reqId, cost: cost)
            } else {
                callEnd(output: "[LLM is streamable]", reqId: reqId, cost: cost)
            }
            return llmResult
        } catch {
            callCatch(error: error, reqId: reqId, cost: cost)
            return LLMResult()
        }
        
    }
    
    
    func callEnd(output: String, reqId: String, cost: Double) {
        for callback in self.callbacks {
            do {
                try callback.on_llm_end(output: output, metadata: [LLM.LLM_REQ_ID_KEY: reqId, LLM.LLM_COST_KEY: "\(cost)"])
            } catch {
                print("call LLM end callback errer: \(error)")
            }
        }
    }
    
    func callStart(prompt: String, reqId: String) {
        for callback in self.callbacks {
            do {
                try callback.on_llm_start(prompt: prompt, metadata: [LLM.LLM_REQ_ID_KEY: reqId])
            } catch {
                print("call LLM start callback errer: \(error)")
            }
        }
    }
    
    func callCatch(error: Error, reqId: String, cost: Double) {
        for callback in self.callbacks {
            do {
                try callback.on_llm_error(error: error, metadata: [LLM.LLM_REQ_ID_KEY: reqId, LLM.LLM_COST_KEY: "\(cost)"])
            } catch {
                print("call LLM start callback errer: \(error)")
            }
        }
    }
    
    func _send(text: String, stops: [String]) async throws -> LLMResult {
        LLMResult()
    }
}
