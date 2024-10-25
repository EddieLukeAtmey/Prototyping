//
//  ABProfilePictureViewController.swift
//  Prototyping
//
//  Created by Ngoc Dang on 21/10/24.
//

import UIKit
import SnapKit

final class ABProfilePictureViewController: UIViewController {

    enum Section: Hashable, CaseIterable {
        case main
    }
    struct CollectionItem: Hashable {
        var url: String?
        var label: String?
    }

    // Collection view constants
    let itemSize = CGSize(width: 64, height: 64)
    let horizontalSpacing: CGFloat = 32 // H Spacing
    let verticalSpacing: CGFloat = 24   // V Spacing
    let itemsPerRow: CGFloat = 3
    let itemsPerColumn: CGFloat = 3

    // View's items
    let backButton = UIButton()
    let titleLabel = UILabel()
    let saveButton = UIButton()

    let profileContentView = UIView()
    let selectedImageView = UIImageView()

    private let currentProfilePictureImageView = UIImageView()
    private let layout = UICollectionViewFlowLayout()
    private lazy var profilePicturesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private lazy var profilePictureDatasource = UICollectionViewDiffableDataSource<Section, CollectionItem>(collectionView: profilePicturesCollectionView)
    { collectionView, indexPath, cellItem in

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfilePictureCollectionViewCell.className, for: indexPath) as! ProfilePictureCollectionViewCell
        cell.bindCellItem(cellItem)
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        reloadCollectionView()
    }

    private func setupUI() {

        // Navigation
        view.addSubview(backButton)
        backButton.backgroundColor = .gray
        backButton.snp.makeConstraints {
            $0.size.equalTo(48)
            $0.left.equalToSuperview().offset(4)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        view.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.text = "Cap nhat anh"
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton.snp.centerY)
            $0.left.equalTo(backButton.snp.right)
            $0.centerX.equalToSuperview()
        }

        // Content
        view.addSubview(profileContentView)
        profileContentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }

        profileContentView.addSubview(selectedImageView)
        selectedImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.size.equalTo(128)
            $0.centerX.equalToSuperview()
        }

        setupCollectionView()

        // Footer
        saveButton.backgroundColor = .systemPink
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func setupCollectionView() {
        layout.itemSize = itemSize
        layout.minimumLineSpacing = verticalSpacing
        layout.minimumInteritemSpacing = horizontalSpacing
        layout.scrollDirection = .vertical

        profilePicturesCollectionView.register(ProfilePictureCollectionViewCell.self, forCellWithReuseIdentifier: ProfilePictureCollectionViewCell.className)
        profilePicturesCollectionView.delegate = self
        profilePicturesCollectionView.isScrollEnabled = false
        profilePicturesCollectionView.allowsMultipleSelection = false

        profileContentView.addSubview(profilePicturesCollectionView)
        profilePicturesCollectionView.snp.makeConstraints {
            $0.width.equalTo(itemSize.width * itemsPerColumn + horizontalSpacing * (itemsPerColumn - 1))
            $0.height.equalTo(itemSize.height * itemsPerRow + verticalSpacing * (itemsPerRow - 1))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(selectedImageView.snp.bottom).offset(56)
        }
    }

    private func reloadCollectionView() {

        let arr = 0..<9
        let data = arr.map { ABProfilePictureViewController.CollectionItem(label: "\($0)") }

        var snapshot = NSDiffableDataSourceSnapshot<Section, CollectionItem>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(data)
        profilePictureDatasource.applySnapshotUsingReloadData(snapshot)

        let selectedIndexPath = IndexPath(item: 0, section: 0)
        profilePicturesCollectionView.selectItem(at: selectedIndexPath,
                                                 animated: false, scrollPosition: .left)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView(self.profilePicturesCollectionView, didSelectItemAt: selectedIndexPath)
        }
    }
}

extension ABProfilePictureViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        selectedImageView.image = renderer.image { context in
            cell.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
}

private final class ProfilePictureCollectionViewCell: UICollectionViewCell {
    let label = UILabel()
    let selectedImage = UIImageView(image: .init(systemName: "checkmark.circle.fill"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    override var isSelected: Bool {
        get { super.isSelected }
        set {
            super.isSelected = newValue
            selectedImage.isHidden = !newValue
            label.layer.borderWidth = newValue ? 2 : 0
        }
    }

    private func setupCell() {
        label.frame = contentView.bounds
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.layer.borderColor = UIColor.red.cgColor
        label.layer.cornerRadius = 32
        label.layer.masksToBounds = true
        label.backgroundColor = .cyan

        contentView.addSubview(label)
        label.snp.makeConstraints { $0.edges.equalToSuperview() }

        selectedImage.tintColor = .orange
        selectedImage.isHidden = true
        selectedImage.backgroundColor = .white
        selectedImage.layer.cornerRadius = 8
        selectedImage.layer.borderWidth = 1
        selectedImage.layer.borderColor = selectedImage.tintColor.cgColor

        contentView.addSubview(selectedImage)
        selectedImage.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.size.equalTo(16)
        }
    }

    func bindCellItem(_ item: ABProfilePictureViewController.CollectionItem) {
        label.text = item.label
    }
}

#Preview {
    ABProfilePictureViewController()
}
