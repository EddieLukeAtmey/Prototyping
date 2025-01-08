//
//  PhotoCell.swift
//  Prototyping
//
//  Created by Eddie on 4/12/24.
//

import UIKit
import Then

final class PhotoCell: UICollectionViewCell {

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let label = UILabel().then {
        $0.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        [imageView, label].forEach {
            contentView.addSubview($0)
            $0.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with color: UIColor, index: Int) {
        imageView.backgroundColor = color.withAlphaComponent(0.5)
        label.text = "\(index)"
    }
}
