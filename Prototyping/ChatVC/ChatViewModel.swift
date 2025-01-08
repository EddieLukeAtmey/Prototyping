//  ChatViewModel.swift
//  Prototyping
//
//  Created by Eddie on 8/1/25.
//  

import Foundation
import Combine

protocol ChatViewModelType {
    var input: ChatViewInput { get }
    var output: ChatViewOutput { get }
}

protocol ChatViewInput {
    func loadConversation()
}

protocol ChatViewOutput {
    var loadConversationSubject: PassthroughSubject<ChatConversationModel, Never> { get }
}

final class ChatViewModel: ChatViewModelType {
    var input: ChatViewInput { self }
    var output: ChatViewOutput { self }
    var loadConversationSubject: PassthroughSubject<ChatConversationModel, Never> = .init()

}

extension ChatViewModel: ChatViewInput {
    func loadConversation() {
        // Dummy data
        let messages = (0..<100).map { _ in
            let chatPerson: ChatPersonModel
            if [0, 1].randomElement()! & 1 == 0 {
                chatPerson = .receiving
            } else {
                chatPerson = .sending
            }

            let length = (10...50).randomElement()!

            let message = String((0..<length).map { _ in
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
            })

            return ChatMessageModel(sender: chatPerson, message: message)
        }

        loadConversationSubject.send(ChatConversationModel(messages: messages))
    }
}

extension ChatViewModel: ChatViewOutput {}

private extension ChatPersonModel {
    static let receiving = ChatPersonModel(name: "Other Person")
    static let sending = ChatPersonModel(name: "Me")
}
