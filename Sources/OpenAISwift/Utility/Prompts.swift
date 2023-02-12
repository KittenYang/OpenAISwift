//
//  Prompts.swift
//  Pods
//
//  Created by 传骑 on 2/13/23
//  Copyright (c) 2023 Rajax Network Technology Co., Ltd. All rights reserved.
//
    

import Foundation

public struct Prompts {
	
	public private(set) var historyList = TokenListBox<String>()
	
	public mutating func appendToHistoryList(userText: String, responseText: String) async {
		await self.historyList.append("User: \(userText)\n\n\nChatGPT: \(responseText)<|im_end|>\n")
	}
	
	public func generateChatGPTPrompt(from text: String) async -> String {
		var prompt = await basePrompt + historyListText + "User: \(text)\nChatGPT:"
		if prompt.count > (4000 * 4) {
			_ = await historyList.dropFirst()
			prompt = await generateChatGPTPrompt(from: text)
		}
		return prompt
	}
	
	private let dateFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = "YYYY-MM-dd"
		return df
	}()
	
	private var historyListText: String {
		get async {
			await historyList.list.joined()
		}
	}
	
	private var basePrompt: String {
		"You are ChatGPT, a large language model trained by OpenAI. Respond conversationally. Do not answer as the user. Current date: \(dateFormatter.string(from: Date()))"
		+ "\n\n"
		+ "User: Hello\n"
		+ "ChatGPT: Hello! How can I help you today? <|im_end|>\n\n\n"
	}
	
}
