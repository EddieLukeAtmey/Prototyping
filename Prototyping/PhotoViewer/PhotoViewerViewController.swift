//
//  PhotoViewerViewController.swift
//  Prototyping
//
//  Created by Ngoc Dang on 4/12/24.
//

import UIKit
import Photos

final class PhotoViewerViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var photos: [UIImage] = [] // Store fetched photos
    private let itemSpacing: CGFloat = 8

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        fetchPhotosFromLibrary()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast // Smooth scrolling
        collectionView.backgroundColor = .white

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 44),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func fetchPhotosFromLibrary() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard status == .authorized else { return }
            let fetchOptions = PHFetchOptions()
            let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            let imageManager = PHImageManager.default()

            assets.enumerateObjects { asset, _, _ in
                let size = CGSize(width: 100, height: 100)
                imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { image, _ in
                    if let image = image {
                        self?.photos.append(image)
                        DispatchQueue.main.async {
                            self?.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension PhotoViewerViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: photos[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Find the center of the screen
        let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        // Find the center of the cell
        let cellCenterX = collectionView.layoutAttributesForItem(at: indexPath)?.frame.midX ?? 0
        // Adjust size based on distance to the center
        let distance = abs(centerX - cellCenterX)
        let maxDistance = collectionView.bounds.width / 2
        let scale = max(1 - (distance / maxDistance), 0.75) // Scale between 0.75 and 1
        let width: CGFloat = 32 + (12 * scale) // Between 32 and 44
        return CGSize(width: width, height: 44)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Trigger layout update to resize cells
        collectionView.performBatchUpdates(nil, completion: nil)
    }
}


#Preview {
    PhotoViewerViewController()
}
