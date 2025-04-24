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
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        let firsts = (1...10).compactMap {
            ChatMessageModel(sender: randomChatPerson, message: formatter.string(from: ($0 as NSNumber))!)
        }

        let messages = firsts + (0..<10).map { _ in
            String((0..<(10...50).randomElement()!).map { _ in
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
            }).thenTransform {
                ChatMessageModel(sender: randomChatPerson, message: $0 as String)
            }
        }

        loadConversationSubject.send(ChatConversationModel(messages: messages.reversed()))
    }

    private var randomChatPerson: ChatPersonModel {
        [0, 1].randomElement()! & 1 == 0
        ? .receiving
        : .sending
    }
}

extension ChatViewModel: ChatViewOutput {}

private extension ChatPersonModel {
    static let receiving = ChatPersonModel(name: "Other Person")
    static let sending = ChatPersonModel(name: "Me")
}
