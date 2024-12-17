//
//  PanModalHostingController2.swift
//  Prototyping
//
//  Created by Eddie on 29/10/24.
//

import UIKit
import SnapKit

final class PanModalHostingController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addPanChildController()
    }

    private func addPanChildController() {
        let child = PanableViewController()
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}

final class PanableViewController: UIViewController {

    private var defaultHeight: CGFloat = 0
    private let minHeight: CGFloat = 120
    private var maxHeight: CGFloat {
        return (view.superview?.bounds.height ?? UIScreen.main.bounds.height) - 120
    }

    private var heightConstraint: Constraint!
    private let panableView = UIView()

    private let tableView = UITableView()
    private lazy var dataSource = UITableViewDiffableDataSource<Int, Int>(tableView: tableView) { tableView, indexPath, itemIdentifier in
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Use default content configuration
        var content = cell.defaultContentConfiguration()
        content.text = "\(itemIdentifier)"
        cell.contentConfiguration = content
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        panableView.backgroundColor = .red.withAlphaComponent(0.3)

        view.addSubview(panableView)
        panableView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.height.equalTo(20)
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(panableView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        // Add pan gesture to handle dragging
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panableView.addGestureRecognizer(panGesture)
        makeDefaultData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Configure the view’s layout using SnapKit
        guard let superview = view.superview else { return }
        // Set the default height as one-third of the superview height
        defaultHeight = superview.bounds.height / 3

        view.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            heightConstraint = make.height.equalTo(defaultHeight).constraint // Adjust height as needed
        }
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        // Calculate the vertical movement
        let translation = gesture.translation(in: view.superview)

        switch gesture.state {
        case .changed:
            // Update top constraint based on the pan movement
            let newHeight = max(minHeight, 
                                min(maxHeight, heightConstraint.layoutConstraints.first!.constant - translation.y))
            heightConstraint.update(offset: newHeight)
            gesture.setTranslation(.zero, in: view.superview)
        case .ended:
            let currentHeight = heightConstraint.layoutConstraints.first?.constant ?? 0

            // Determine the snap position based on proximity
            let snapHeight: CGFloat
            if currentHeight < (defaultHeight / 2) {
                snapHeight = minHeight // Snap to the minimum height
            } else if currentHeight > ((maxHeight + defaultHeight) / 2) {
                snapHeight = maxHeight // Snap to the maximum height
            } else {
                snapHeight = defaultHeight // Snap to the default height
            }

            heightConstraint.update(offset: snapHeight)
            UIView.animate(withDuration: 0.3) {
                self.view.superview?.layoutIfNeeded()
            }        
        default:
            break
        }
    }

    private func makeDefaultData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()

        // Use a single section with values 0 to 10 as items
        snapshot.appendSections([0])
        snapshot.appendItems(Array(0...10), toSection: 0)

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

#Preview {
    PanModalHostingController2()
}
