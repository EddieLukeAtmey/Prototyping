//
//  PhotoCell.swift
//  Prototyping
//
//  Created by Ngoc Dang on 4/12/24.
//

import UIKit

final class PhotoCell: UICollectionViewCell {

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with color: UIColor) {
        imageView.backgroundColor = color
    }
}
