//  ChatConversationModel.swift
//  Prototyping
//
//  Created by Eddie on 8/1/25.
//  

import Foundation

struct ChatConversationModel {
    var messages = [ChatMessageModel]()
}

struct ChatMessageModel: Hashable {
    let id = UUID()
    var sender: ChatPersonModel
    var message: String
}

struct ChatPersonModel: Hashable {
    var name: String
    var image: String?
}
