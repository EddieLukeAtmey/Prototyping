//
//  AtmCellContentView.swift
//  Prototyping
//
//  Created by Ngoc Dang on 29/10/24.
//

import UIKit
import SnapKit

final class AtmCellContentView: UIView {
    var isSelected: Bool = false { didSet {
        // update UI
        if isSelected {
            backgroundColor = .green.withAlphaComponent(0.3)
            layer.borderWidth = 1

        } else {
            backgroundColor = .white
            layer.borderWidth = 0

            applySketchShadow(color: .black,
                              alpha: 0.1,
                              blur: 12)
        }
    }}

    // View's Properties
    let imageView = UIImageView(image: .init(systemName: "creditcard")) // Fixed image
    let nameLabel = UILabel()
    let addressLabel = UILabel()
    let distanceLabel = UILabel()
    let workingStatusLabel = UILabel()
    let workingTimeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    private func setupLayout() {
        backgroundColor = .white
        layer.borderColor = UIColor.green.cgColor
        layer.cornerRadius = 12

        let mainHStackView = UIStackView()
        mainHStackView.alignment = .center
        addSubview(mainHStackView)
        mainHStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.horizontalEdges.equalToSuperview()
        }

        mainHStackView.addArrangedSubview(imageView)
        imageView.contentMode = .center
        imageView.snp.makeConstraints { $0.size.equalTo(48) }

        let nameVStackView = UIStackView()
        nameVStackView.axis = .vertical
        nameVStackView.addArrangedSubview(nameLabel)
        nameVStackView.addArrangedSubview(addressLabel)
        addressLabel.font = .systemFont(ofSize: 12, weight: .light)

        mainHStackView.addArrangedSubview(nameVStackView)

        let distanceLabelContainer = UIView()
        distanceLabelContainer.addSubview(distanceLabel)
        distanceLabel.textAlignment = .center
        distanceLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
        mainHStackView.addArrangedSubview(distanceLabelContainer)

        let workingStackView = UIStackView()
        addSubview(workingStackView)
        workingStackView.addArrangedSubview(workingStatusLabel)
        workingStackView.addArrangedSubview(workingTimeLabel)

        workingStackView.snp.makeConstraints {
            $0.top.equalTo(mainHStackView.snp.bottom)
            $0.left.equalTo(nameVStackView.snp.left)
            $0.bottom.equalToSuperview().inset(20)
        }
    }

    func bindEntity(_ entity: AtmCellEntity) {
        nameLabel.text = entity.name
        addressLabel.text = entity.address
        distanceLabel.text = entity.distance
        workingStatusLabel.text = entity.workingStatus.text
        workingStatusLabel.textColor = entity.workingStatus.textColor

        if let workingTime = entity.workingTime {
            workingTimeLabel.text = "  •  " + workingTime
        }
        else {
            workingTimeLabel.text = ""
        }

        workingTimeLabel.isHidden = entity.workingStatus == .maintenance
    }
}

#Preview {

    let vc = UIViewController()
    let view = AtmCellContentView()
    vc.view.addSubview(view)
    view.isSelected = false
//    vc.view.backgroundColor = .lightGray

    var entity = AtmCellEntity()
    entity.name = "ATM Hoàng Cầu"
    entity.address = "Toà nhà Geleximco, 36 P. Hoàng Cầu"
    entity.distance = "750 m"
    entity.workingStatus = .active
    entity.workingTime = "24/7"
    view.bindEntity(entity)

    view.snp.makeConstraints {
        $0.horizontalEdges.equalToSuperview()
        $0.center.equalToSuperview()
    }
    return vc
}

struct AtmCellEntity {
    enum WorkingStatus {
        case active, maintenance
        var text: String {
            switch self {
            case.active: return "Hoạt động"
            case .maintenance: return "Đang bảo trì"
            }
        }

        var textColor: UIColor {
            switch self {
            case.active: return .green
            case .maintenance: return .gray
            }
        }
    }

    var name: String?
    var address: String?
    var workingStatus: WorkingStatus = .active

    var workingTime: String?
    var distance: String?
//    var location: CLLocationCoordinate2D?
}
