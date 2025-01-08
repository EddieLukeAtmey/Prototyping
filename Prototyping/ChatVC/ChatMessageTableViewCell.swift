//  ChatMessageTableViewCell.swift
//  Prototyping
//
//  Created by Eddie on 8/1/25.
//  

import UIKit
import SnapKit

final class ChatMessageTableViewCell: UITableViewCell {
    private var isOutgoing: Bool = true { didSet {
        rightContentConstaint.update(priority: isOutgoing ? .high : .low)
        senderLabel.textAlignment = isOutgoing ? .right : .left
    }}

    private let contentStack = UIStackView()
    private let senderLabel = UILabel()
    private let messageBubbleView = UIView()
    private let contentLabel = UILabel()
    private var rightContentConstaint: Constraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    private func setupCell() {
        setupContentStack()

        // Contents
        messageBubbleView.addSubview(contentLabel)
        contentLabel.numberOfLines = 0
        contentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }

        contentStack.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.width.lessThanOrEqualToSuperview().multipliedBy(0.6)
            $0.left.equalToSuperview().inset(4).priority(.medium)
            rightContentConstaint = $0.right.equalToSuperview().inset(4).priority(.high).constraint
        }

        setupStyle()
    }

    private func setupContentStack() {
        contentView.addSubview(contentStack)
        contentStack.axis = .vertical

        contentStack.addArrangedSubview(senderLabel)
        contentStack.addArrangedSubview(messageBubbleView)

        // TODO: add time, read...
    }

    private func setupStyle() {
        senderLabel.font = .systemFont(ofSize: 12)

        // Transform upside down
        transform = CGAffineTransform(rotationAngle: .pi)
        messageBubbleView.layer.cornerRadius = 8
        messageBubbleView.backgroundColor = .cyan.withAlphaComponent(0.5)
    }

    func bindMessage(_ msg: ChatMessageModel) {
        senderLabel.text = msg.sender.name
        contentLabel.text = msg.message
        isOutgoing = msg.sender.isOutgoing
    }
}

private extension ChatPersonModel {
    var isOutgoing: Bool {
        name == "Me"
    }
}
