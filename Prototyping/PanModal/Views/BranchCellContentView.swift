//
//  BranchCellContentView.swift
//  Prototyping
//
//  Created by Eddie on 29/10/24.
//

import UIKit

final class BranchCellContentView: UIView {
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
    let imageView = UIImageView(image: .init(systemName: "house")) // Fixed image
    let nameLabel = UILabel()
    let addressLabel = UILabel()
    let distanceLabel = UILabel()
    
    let branchStatusLabel = UILabel()
    let workingTimesStackView = UIStackView()
    let atmWorkingTimeLabel = UILabel()

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

        let detailVStackView = UIStackView()
        detailVStackView.axis = .vertical
        detailVStackView.spacing = 8
        detailVStackView.addArrangedSubview(branchContainerView)
        detailVStackView.addArrangedSubview(openTimesContainerView)
        detailVStackView.addArrangedSubview(atmContainerView)

        addSubview(detailVStackView)
        detailVStackView.snp.makeConstraints {
            $0.top.equalTo(mainHStackView.snp.bottom)
            $0.left.equalTo(nameVStackView.snp.left)
            $0.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
        }
    }

    private var branchContainerView: UIView {
        let stack = UIStackView()
        stack.spacing = 12

        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.text = "Chi nhánh"

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(branchStatusLabel)

        titleLabel.snp.makeConstraints { $0.width.equalTo(80) }

        return stack
    }

    private var openTimesContainerView: UIView {
        let stack = UIStackView()
        stack.alignment = .center
        stack.spacing = 12

        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.text = "Mở cửa"

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(workingTimesStackView)
        workingTimesStackView.axis = .vertical

        titleLabel.snp.makeConstraints { $0.width.equalTo(80) }

        return stack
    }


    private var atmContainerView: UIView {
        let stack = UIStackView()
        stack.spacing = 12

        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.text = "ATM"

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(atmWorkingTimeLabel)

        titleLabel.snp.makeConstraints { $0.width.equalTo(80) }

        return stack
    }


    func bindEntity(_ entity: BranchCellEntity) {
        nameLabel.text = entity.name
        addressLabel.text = entity.address
        distanceLabel.text = entity.distance
        
        branchStatusLabel.text = entity.workingStatus.text
        branchStatusLabel.textColor = entity.workingStatus.textColor

        workingTimesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        entity.workingTimes.forEach {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14)
            label.text = $0
            workingTimesStackView.addArrangedSubview(label)
        }

        atmWorkingTimeLabel.text = entity.atmWorkingTime
    }
}

#Preview {

    let vc = UIViewController()
    let view = BranchCellContentView()
    vc.view.addSubview(view)
    view.isSelected = false
//    vc.view.backgroundColor = .lightGray

    var entity = BranchCellEntity()
    entity.name = "ATM Hoàng Cầu"
    entity.address = "Toà nhà Geleximco, 36 P. Hoàng Cầu"
    entity.distance = "750 m"

    entity.workingTimes = ["8:00 - 16:00 (t2 - t6)",
                           "8:00 - 12:00 (t7)"]
    entity.workingStatus = .active
    entity.atmWorkingTime = "24/7"
    view.bindEntity(entity)

    view.snp.makeConstraints {
        $0.horizontalEdges.equalToSuperview()
        $0.center.equalToSuperview()
    }
    return vc
}

struct BranchCellEntity {
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

    var workingTimes = [String]()
    var atmWorkingTime: String?
    var distance: String?
//    var location: CLLocationCoordinate2D?
}
