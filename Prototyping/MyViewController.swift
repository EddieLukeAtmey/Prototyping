//
//  MyViewController.swift
//  Prototyping
//
//  Created by Eddie on 23/7/24.
//

import UIKit

class MyViewController: UIViewController {

    enum TableSection: CaseIterable {
        case main
    }

    struct ContentItem: Hashable {
        let id = UUID()
        let text: String
    }

    let tbContent = UITableView()

    //MARK: datasource
    var tableViewDatasource: UITableViewDiffableDataSource<TableSection, ContentItem>!

    override func viewDidLoad() {
        super.viewDidLoad()

        NSLayoutConstraint.activate([
            tbContent.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tbContent.topAnchor.constraint(equalTo: view.topAnchor),
            tbContent.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tbContent.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        tableViewDatasource = .init(tableView: tbContent) { tableView, indexPath, item in

            let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
            cell.leftLabel.text = String(indexPath.row)
            cell.rightLabel.text = item.text

            if indexPath.row == 8 {
                cell.accessoryType = .checkmark
            }

            return cell
        }
        configureTableHeader()
        applySnapshot()
    }

    override func loadView() {
        super.loadView()
        self.view = UIView()

        view.addSubview(tbContent)

        tbContent.translatesAutoresizingMaskIntoConstraints = false
        tbContent.register(MyTableViewCell.self, forCellReuseIdentifier: "MyTableViewCell")
        tbContent.delegate = self
//        tbContent.dataSource = self
    }

    func configureTableHeader() {
        // Create an instance of MyTableViewCell

        // Set the table header view to the contentView of the cell
//        tbContent.tableHeaderView = headerCell.contentView
    }

    func applySnapshot() {

        var snapshot = NSDiffableDataSourceSnapshot<TableSection, ContentItem>()
        snapshot.appendSections([.main])

        let content = (0..<10).map { _ in ContentItem(text: String(Int.random(in: 0...100)) + "%") }
        snapshot.appendItems(content, toSection: .main)


        tableViewDatasource.apply(snapshot, animatingDifferences: true)
    }
}

extension MyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell") as! MyTableViewCell
        headerCell.leftLabel.text = "Header"
        headerCell.rightLabel.text = "Fixed Content"
        return headerCell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60 // Adjust height as needed
    }
}

//extension MyViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        content.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
//        cell.leftLabel.text = String(indexPath.row)
//        cell.rightLabel.text = content[indexPath.row]
//
//        if indexPath.row == 8 {
//            cell.accessoryType = .checkmark
//        }
//        return cell
//    }
//}

class MyTableViewCell: UITableViewCell {
    let leftLabel = UILabel()
    let rightLabel = UILabel()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        leftLabel.textAlignment = .center
        rightLabel.textAlignment = .center

        let stv = UIStackView()
        stv.axis = .horizontal
        stv.distribution = .fillEqually
        stv.translatesAutoresizingMaskIntoConstraints = false
        stv.addArrangedSubview(leftLabel)
        stv.addArrangedSubview(rightLabel)

        contentView.addSubview(stv)
        NSLayoutConstraint.activate([
            stv.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stv.topAnchor.constraint(equalTo: self.topAnchor),
            stv.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stv.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

#Preview {
    MyViewController()
}
