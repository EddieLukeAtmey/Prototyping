//  ChatViewController.swift
//  Prototyping
//
//  Created by Eddie on 8/1/25.
//  

import UIKit
import SnapKit
import Then
import Combine

final class ChatViewController: UIViewController {
    let viewModel: ChatViewModelType
    init(viewModel: ChatViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { nil }
    private var cancelable = Set<AnyCancellable>()

    let tableView = UITableView()
    private lazy var dataSource = UITableViewDiffableDataSource<Int, ChatMessageModel>(tableView: tableView) { tableView, indexPath, itemIdentifier in
        tableView.dequeueReusableCell(withIdentifier: ChatMessageTableViewCell.className, for: indexPath).then {
            ($0 as? ChatMessageTableViewCell)?.bindMessage(itemIdentifier)
        }
    }

    // Input Controls
    private let inputContainerView = UIView()
    private let inputContainerStack = UIStackView()
    private let inputTextView = UITextView()
    private var textViewHeightConstraint: Constraint!
    private lazy var inputContentEffectView = UIVisualEffectView(effect: blurEffectWithTrait)
    private let sendButton = UIButton(type: .system)

    private var blurEffectWithTrait: UIBlurEffect {
        if traitCollection.userInterfaceStyle == .dark {
            .init(style: .systemChromeMaterialDark)
        } else {
            .init(style: .extraLight)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTable()
        bindOutputs()
        observeThemeChange()

        viewModel.input.loadConversation()
        becomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setupUI() {
        title = "Chat Conversation"
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
//        navigationController?.isNavigationBarHidden = true

        view.addSubview(tableView)
//        tableView.transform = .init(scaleX: 1, y: -1)

        setupInputView()

        tableView.snp.makeConstraints {
//            $0.horizontalEdges.top.equalToSuperview()
//            $0.bottom.equalTo(inputContainerView.snp.top)
            $0.edges.equalToSuperview()
        }
    }

    private func setupTable() {
        tableView.register(ChatMessageTableViewCell.self, forCellReuseIdentifier: ChatMessageTableViewCell.className)
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.contentLayoutGuide.snp.makeConstraints {
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }

//        edgesForExtendedLayout = .bottom
//        tableView.layoutIfNeeded()
//        tableView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width - 10)
    }

    private func setupInputView() {
        view.addSubview(inputContainerView)
        inputContentEffectView.then(inputContainerView.addSubview).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        inputContainerView.addSubview(inputContainerStack)
        inputContainerStack.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview().inset(8)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-8)
        }

        // Configure the input container
        inputContainerStack.spacing = 8
        inputContainerStack.alignment = .bottom

        // Configure the text view
        inputTextView.font = UIFont.systemFont(ofSize: 16)
        inputTextView.layer.cornerRadius = 8
        inputTextView.isScrollEnabled = false
        inputTextView.delegate = self

        // Configure the send button
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)

        // Add text view and button to the container
        inputContainerStack.addArrangedSubview(inputTextView)
        inputContainerStack.addArrangedSubview(sendButton)

        // Set constraints for text view and button
        inputTextView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(36)
            $0.height.lessThanOrEqualTo(120)
            textViewHeightConstraint = $0.height.equalTo(0).priority(.high).constraint
        }
        sendButton.snp.makeConstraints { $0.width.equalTo(60) }

        inputContainerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    private func bindOutputs() {
        viewModel.output.loadConversationSubject.receive(on: DispatchQueue.main).sink { [weak self] in
            self?.reloadConversation($0)
        }.store(in: &cancelable)
    }

    private func reloadConversation(_ convo: ChatConversationModel) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ChatMessageModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(convo.messages)
        dataSource.apply(snapshot)

        tableView.scrollToRow(at: .init(row: convo.messages.count - 1, section: 0),
                              at: .bottom, animated: false)
    }

    @objc private func sendMessage() {
        guard let text = inputTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return }
        print("Send Message: \(text)")
        inputTextView.text = nil
        textViewDidChange(inputTextView) // Adjust height after clearing text
    }

    private func observeThemeChange() {
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
            self.inputContentEffectView.effect = self.blurEffectWithTrait
        }
    }
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let maxHeight: CGFloat = 120
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
        textView.isScrollEnabled = size.height > maxHeight
        textViewHeightConstraint.update(offset: size.height)
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        inputContainerView.frame.height
    }
}

#Preview {
    let root = ChatViewController.init(viewModel: ChatViewModel())
    let nav = UINavigationController(rootViewController: root)
    return nav
}
