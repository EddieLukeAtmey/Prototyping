//  TableVC.swift
//  Prototyping
//
//  Created by Eddie on 13/3/25.
//  

import UIKit
import Then
import SnapKit

private let cellId = "cell"
final class TableVC: UIViewController {

    let tableView = UITableView()
    lazy var dataSource = UITableViewDiffableDataSource<String, Int> (tableView: tableView) { tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = "\(item)"
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
//        view.backgroundColor = .cyan
    }

    func setupTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(SectionHeader.self, forHeaderFooterViewReuseIdentifier: SectionHeader.className)
//        tableView.backgroundColor = .red.withAlphaComponent(0.8)
        defer { print(tableView.sectionHeaderTopPadding) }

        // Setup Block
        tableView.contentInsetAdjustmentBehavior = .never
//        tableView.sectionHeaderTopPadding = .leastNormalMagnitude
//        tableView.sectionHeaderTopPadding = 1/9
        tableView.sectionHeaderTopPadding = 0.11
//        tableView.sectionHeaderTopPadding = .zero
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        // End setup

        // Layout Constraint
        tableView.then(view.addSubview).snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        // Data
        let sections = "1 2 3 4 5".split(separator: " ").map(String.init)
        var snapshot = NSDiffableDataSourceSnapshot<String, Int>()
        snapshot.appendSections(sections)

        var i = 0
        let count = 5
        sections.forEach {
            snapshot.appendItems(Array(i..<i+count), toSection: $0)
            i+=count
        }

        dataSource.applySnapshotUsingReloadData(snapshot)
    }
}

extension TableVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        24 + 24 + 20
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let data = dataSource.sectionIdentifier(for: section) else { return nil }

        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeader.className) as? SectionHeader else {
            return nil
        }
        header.configure(with: data)
        return header
    }
}

final class SectionHeader: UITableViewHeaderFooterView {
    private let label = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(label)
        label.font = .boldSystemFont(ofSize: 20)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-12)
        }
//        contentView.backgroundColor = .green
    }

    required init?(coder: NSCoder) { nil }

    func configure(with section: String) {
        label.text = section
    }
}

#Preview {
    TableVC()
}
