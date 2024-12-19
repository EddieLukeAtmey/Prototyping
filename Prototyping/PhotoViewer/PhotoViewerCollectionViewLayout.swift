//
//  PhotoViewerCollectionViewLayout.swift
//  Prototyping
//
//  Created by Eddie on 16/12/24.
//

import UIKit

/// use when scrolling is not in motion
final class PhotoViewerCollectionViewLayout: UICollectionViewFlowLayout {

    var isScrollingInMotion = false

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        guard !isScrollingInMotion, let collectionView = collectionView else { return attributes }
        guard let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first else { return attributes }

        let updatedAttributes = attributes.map { $0.copy() as! UICollectionViewLayoutAttributes }
        let deltaWidth = (itemSize.height - itemSize.width) / 2
        let itemSpacing = minimumInteritemSpacing + deltaWidth + minimumLineSpacing

        for attribute in updatedAttributes {
             if attribute.indexPath.item == selectedIndexPath.item {
                attribute.size.width = attribute.size.height
            } else {
                if attribute.indexPath.item > selectedIndexPath.item {
                    // Custom item on the right
                    attribute.frame.origin.x += itemSpacing

                } else {
                    // Custom item on the left
                    attribute.frame.origin.x -= itemSpacing
                }
            }
        }

        return updatedAttributes
    }
}

#Preview {
    PhotoViewerViewController()
}
