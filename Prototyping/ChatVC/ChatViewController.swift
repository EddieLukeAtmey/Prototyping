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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTable()
        bindOutputs()

        viewModel.input.loadConversation()
    }

    private func setupUI() {
        title = "Chat Conversation"
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide.snp.verticalEdges)
        }
        tableView.transform = .init(rotationAngle: .pi)
    }

    private func setupTable() {
        tableView.register(ChatMessageTableViewCell.self, forCellReuseIdentifier: ChatMessageTableViewCell.className)
        tableView.separatorStyle = .none
        tableView.scrollsToTop = true
        tableView.sectionHeaderTopPadding = 0
        tableView.clipsToBounds = false
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
    }
}

#Preview {
    let root = ChatViewController.init(viewModel: ChatViewModel())
    let nav = UINavigationController(rootViewController: root)
    return nav
}
