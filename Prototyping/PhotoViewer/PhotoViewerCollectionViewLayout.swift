//
//  PhotoViewerCollectionViewLayout.swift
//  Prototyping
//
//  Created by Ngoc Dang on 16/12/24.
//

import UIKit

/// use when scrolling is not in motion
final class PhotoViewerCollectionViewLayout: UICollectionViewFlowLayout {
    init(scrollingLayout: UICollectionViewFlowLayout) {
        super.init()
        scrollDirection = scrollingLayout.scrollDirection
        minimumInteritemSpacing = scrollingLayout.minimumInteritemSpacing
        sectionInset = scrollingLayout.sectionInset
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        guard let collectionView = collectionView else { return attributes }
        guard let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first else { return attributes }

        let updatedAttributes = attributes.map { $0.copy() as! UICollectionViewLayoutAttributes }
        let itemSpacing = minimumInteritemSpacing + 5

        for attribute in updatedAttributes {
            if attribute.indexPath.item > selectedIndexPath.item {
                // Custom item on the right
                attribute.frame.origin.x += itemSpacing

            } else if attribute.indexPath.item == selectedIndexPath.item {
                attribute.size.width = attribute.size.height
            } else {
                // Custom item on the left
                attribute.frame.origin.x -= itemSpacing
            }
        }

        return updatedAttributes
    }
}

#Preview {
    PhotoViewerViewController()
}
