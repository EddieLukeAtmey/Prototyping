//
//  SnapkitViewController.swift
//  Prototyping
//
//  Created by Eddie on 25/7/24.
//

import UIKit
import SnapKit

final class SnapkitViewController: UIViewController {

    let navigationView = UIView()
    let navigationLeftView = UIView()
    let stvTitleView = UIStackView()

    let titleLabel = UILabel()
    let maxTitleFontSize: CGFloat = 28
    let minTitleFontSize: CGFloat = 16

    let subTitleLabel = UILabel()
    let maxSubTitleFontSize: CGFloat = 14
    let minSubTitleFontSize: CGFloat = 12

    let maxTitleVerticalSpacing:CGFloat = 4

    let scrollView = UIScrollView()
    let navigatorViewHeight: CGFloat = 48
    var navigationViewTopConstraint: Constraint?

    override func loadView() {
        super.loadView()
        view = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationUI()
        setupTitleViewContent()
        setUpScrollView()
    }

    private func setupNavigationUI() {
        // top view
        let topPinView = UIView()
        topPinView.backgroundColor = .cyan
        view.addSubview(topPinView)
        topPinView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }

        navigationView.backgroundColor = .green
        navigationView.layer.name = "navigationView"
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(navigatorViewHeight)
        }

        // Left icon
        navigationLeftView.backgroundColor = .black
        navigationLeftView.layer.name = "navigationLeftView"
        navigationView.addSubview(navigationLeftView)
        navigationLeftView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(navigationView.snp.leading).offset(4)
            $0.size.equalTo(navigatorViewHeight)
        }

        let backButton = UIButton()
        navigationLeftView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setupTitleViewContent() {

        // Stack
        stvTitleView.axis = .vertical
        stvTitleView.spacing = maxTitleVerticalSpacing
        stvTitleView.alignment = .leading // Default

        // Title
        titleLabel.font = .systemFont(ofSize: maxTitleFontSize, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.text = "zxjkchvnalkjwdfsq 9238ryhafosidzj lvnsfigu 1329preyf"
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        stvTitleView.addArrangedSubview(titleLabel)

        // Subtitle
        subTitleLabel.font = .systemFont(ofSize: 8)
        subTitleLabel.text = "Bạn sẽ nhận lãi cuối kỳ"
        subTitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        stvTitleView.addArrangedSubview(subTitleLabel)
    }

    func setUpScrollView() {
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.contentInset = UIEdgeInsets(top: navigatorViewHeight, left: 0, bottom: 0, right: 0)

        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        let contentScrollView = UIView()
        scrollView.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height)
        }

        contentScrollView.addSubview(stvTitleView)
        stvTitleView.snp.makeConstraints {
            // Vertical
            $0.top.greaterThanOrEqualTo(navigationView.snp.top)
            $0.top.lessThanOrEqualTo(navigationView.snp.bottom)
//            $0.top.equalTo(navigationView.snp.bottom).priority(997)
            $0.top.equalToSuperview().priority(990)
//            navigationViewTopConstraint = $0.top.equalTo(navigationLeftView.snp.bottom).priority(999).constraint
//            $0.bottom.equalToSuperview()

            // Horizontal
            $0.leading.equalTo(navigationLeftView.snp.leading)
            $0.centerX.equalToSuperview()
        }

        let contentBelow = UIView()
        let gradient = CAGradientLayer()
        gradient.frame = UIScreen.main.bounds
        gradient.colors = [UIColor.red.withAlphaComponent(0.5).cgColor, UIColor.blue.withAlphaComponent(0.5).cgColor]
        contentBelow.layer.insertSublayer(gradient, at: 0)

        contentScrollView.addSubview(contentBelow)
        stvTitleView.layoutIfNeeded()
        contentBelow.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(stvTitleView.snp.bottom).priority(970)
//            $0.top.equalTo(stvTitleView.snp.bottom).priority(989)
//            $0.top.equalToSuperview().offset(titleView.frame.height)

            $0.height.equalTo(820)
            $0.bottom.equalToSuperview()
        }
    }
}

extension SnapkitViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setSizeTitleLabel(offsetY: scrollView.contentOffset.y)
    }

    fileprivate func setSizeTitleLabel(offsetY: Double) {

        if offsetY >= 0 { // is at top most
            print("is at top most")
            fixedMinTitleSize()
            return
        }

        // Is scrolled down
        // Adjust properties
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        subTitleLabel.textAlignment = .left
        stvTitleView.alignment = .leading

        let absOffsetY = abs(offsetY)
        if absOffsetY >= navigatorViewHeight {
            print("is already below navigator")
            fixedMaxTitleSize()
            return
        }

        // Offset should never exceed maxOffset a.k.a navigatorViewHeight
        let resrictedOffsetY = min(absOffsetY, navigatorViewHeight)

        let titleFontSize = getCurrentFontSize(currentOffset: resrictedOffsetY, minFontSize: minTitleFontSize, maxFontSize: maxTitleFontSize)
        titleLabel.font = .systemFont(ofSize: titleFontSize)

        let subTitleFontSize = getCurrentFontSize(currentOffset: resrictedOffsetY, minFontSize: minSubTitleFontSize, maxFontSize: maxSubTitleFontSize)
        subTitleLabel.font = .systemFont(ofSize: subTitleFontSize)

        let titlesVerticalSpacing = maxTitleVerticalSpacing - (resrictedOffsetY / navigatorViewHeight) * maxTitleVerticalSpacing
        stvTitleView.spacing = titlesVerticalSpacing
        print("\(#function) offSet: \(offsetY)\t fontSize: \(titleFontSize)\t subtitleSize: \(subTitleFontSize)\t topOffset: \(titlesVerticalSpacing)")
    }

    func fixedMinTitleSize() {
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        subTitleLabel.textAlignment = .center

        titleLabel.font = .systemFont(ofSize: minTitleFontSize)
        subTitleLabel.font = .systemFont(ofSize: minSubTitleFontSize)

        stvTitleView.spacing = 0
        stvTitleView.alignment = .center
    }

    func fixedMaxTitleSize() {
        titleLabel.font = .systemFont(ofSize: maxTitleFontSize)
        subTitleLabel.font = .systemFont(ofSize: maxSubTitleFontSize)
        stvTitleView.spacing = maxTitleVerticalSpacing
    }

    func getCurrentFontSize(currentOffset: CGFloat, minFontSize: CGFloat, maxFontSize: CGFloat) -> CGFloat {
        let rangeFontSize = maxFontSize - minFontSize
        let normalizedOffset = currentOffset / navigatorViewHeight
        let currentFontSize = minFontSize + normalizedOffset * rangeFontSize
        return currentFontSize
    }
}

#Preview {
    SnapkitViewController()
}
