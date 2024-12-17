//
//  SkeletonTableViewController.swift
//  Prototyping
//
//  Created by Eddie on 5/12/24.
//

import UIKit
import SkeletonView
import SnapKit
import Then

final class SkeletonTableViewController: UITableViewController {

    lazy var datasource = UITableViewDiffableDataSource<Int, Int>(tableView: tableView) { tableView, indexPath, item in
        tableView.dequeueReusableCell(withIdentifier: SkeletonTableViewCell.className, for: indexPath)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SkeletonTableViewCell.self, forCellReuseIdentifier: SkeletonTableViewCell.className)
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        reloadData()

        tableView.tableFooterView = UIView().then { [weak self] in
            $0.backgroundColor = .black
            UIButton().then {
                $0.setTitle("loadMore", for: .normal)
                $0.addTarget(self, action: #selector(self?.showLoadMore), for: .touchUpInside)
                $0.backgroundColor = .cyan
            }.then($0.addSubview(_:)).snp.makeConstraints { $0.center.equalToSuperview() }
        }


    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLast = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        (cell as? SkeletonTableViewCell)?.separator.isHidden = isLast
        //        cell.contentView.showAnimatedGradientSkeleton()
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendItems((0..<10).compactMap(Int.init), toSection: 0)

        datasource.applySnapshotUsingReloadData(snapshot) {
//            self.showLoadMore()
        }
    }

    @objc private func showLoadMore() {

        tableView.tableFooterView = nil

//        let loadMoreView = SkeletonTableViewCell()
//        tableView.addSubview(loadMoreView)
//        let size = loadMoreView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        loadMoreView.frame.origin.y = tableView.contentOffset.y
//        tableView.contentOffset.y += size.height
//        loadMoreView.contentView.showAnimatedGradientSkeleton()
    }

//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        UIView().then { $0.backgroundColor = .purple.withAlphaComponent(0.2) }
//    }
}

final class SkeletonTableViewCell: UITableViewCell {

    let separator = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        selectionStyle = .none
        let imgView = UIImageView()
        let titleLabel = UILabel()
        let description1Label = UILabel()
        let description2Label = UILabel()
        let statusLabel = UILabel()

        UIStackView().then { contentStack in
            contentStack.spacing = 12
            contentStack.alignment = .top
            contentStack.isSkeletonable = true
            contentStack.addArrangedSubview(imgView)
            UIStackView().then {
                $0.axis = .vertical
                $0.spacing = 4
                $0.isSkeletonable = true
                $0.addArrangedSubview(titleLabel)
                $0.addArrangedSubview(description1Label)
                $0.addArrangedSubview(description2Label)
            }.do(contentStack.addArrangedSubview)

            contentStack.addArrangedSubview(statusLabel)

        }.then(contentView.addSubview).snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        separator.backgroundColor = .lightGray
        contentView.addSubview(separator)
        contentView.isSkeletonable = true

        imgView.snp.makeConstraints { $0.size.equalTo(24) }

        statusLabel.snp.makeConstraints {
            $0.width.equalTo(49)
            $0.height.equalTo(16)
        }
        titleLabel.snp.makeConstraints { $0.height.equalTo(24) }
        description1Label.snp.makeConstraints { $0.height.equalTo(16) }
        description2Label.snp.makeConstraints { $0.height.equalTo(16) }

        separator.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }

        // Make Skeleton
        imgView.skeletonCornerRadius = 12

        titleLabel.lastLineFillPercent = 65
        description1Label.lastLineFillPercent = 32
        description2Label.lastLineFillPercent = 76
        statusLabel.lastLineFillPercent = 100

        titleLabel.linesCornerRadius = 12
        description1Label.linesCornerRadius = 8
        description2Label.linesCornerRadius = 8
        statusLabel.linesCornerRadius = 8

        titleLabel.skeletonTextLineHeight = .relativeToConstraints
        description1Label.skeletonTextLineHeight = .relativeToConstraints
        description2Label.skeletonTextLineHeight = .relativeToConstraints
        statusLabel.skeletonTextLineHeight = .relativeToConstraints

        [imgView, titleLabel, description1Label, description2Label, statusLabel].forEach {
            $0.isSkeletonable = true
//            $0.showAnimatedGradientSkeleton()
        }

        imgView.backgroundColor = .carrot.withAlphaComponent(0.3)
        titleLabel.backgroundColor = .black.withAlphaComponent(0.2)
        description1Label.backgroundColor = .red.withAlphaComponent(0.3)
        description2Label.backgroundColor = .green.withAlphaComponent(0.3)
        statusLabel.backgroundColor = .carrot.withAlphaComponent(0.3)

//        statusLabel.showAnimatedGradientSkeleton()
//        titleLabel.showAnimatedGradientSkeleton()
//        description1Label.showAnimatedGradientSkeleton()
//        description2Label.showAnimatedGradientSkeleton()
//        [titleLabel, description1Label, description2Label].forEach {
//            $0.isSkeletonable = true
//            $0.showAnimatedGradientSkeleton()
//        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if contentView.sk.isSkeletonActive {
            contentView.hideSkeleton()
            contentView.showAnimatedGradientSkeleton()
        }
    }
}

#Preview {
    SkeletonTableViewController()
}
