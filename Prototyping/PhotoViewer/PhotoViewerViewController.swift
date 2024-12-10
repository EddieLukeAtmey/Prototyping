//
//  PhotoViewerViewController.swift
//  Prototyping
//
//  Created by Ngoc Dang on 4/12/24.
//

import UIKit
import SnapKit
import Then

final class PhotoViewerViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let itemSpacing: CGFloat = 8

    private let dummyData: [UIColor] = [
        .carrot.withAlphaComponent(0.3),
        .black.withAlphaComponent(0.2),
        .red.withAlphaComponent(0.3),
        .green.withAlphaComponent(0.3),

        .carrot.withAlphaComponent(0.5),
        .black.withAlphaComponent(0.5),
        .red.withAlphaComponent(0.5),
        .green.withAlphaComponent(0.5),

        .carrot.withAlphaComponent(0.7),
        .black.withAlphaComponent(0.7),
        .red.withAlphaComponent(0.7),
        .green.withAlphaComponent(0.7)
    ] //.shuffled()

    lazy var dataSource = UICollectionViewDiffableDataSource<Int, UIColor>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
        (collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.className, for: indexPath) as? PhotoCell)?
            .then { $0.configure(with: itemIdentifier) }
    }

    private var isScrollingInMotion = false
    private var isUserScrolling = false

    // PageVC
    private var pageViewController: UIPageViewController!
    private var pageViewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupPageView()
        reloadCollectionView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = itemSpacing

        let sideInset = (view.bounds.width - 44) / 2 // Ensure first and last items center-align
        layout.sectionInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.className)
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast // Smooth scrolling
        collectionView.backgroundColor = .white.withAlphaComponent(0.5)

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }

        let middleIndicator = UIView()
        middleIndicator.backgroundColor = .lightGray
        view.addSubview(middleIndicator)
        middleIndicator.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(1)
            $0.centerX.equalToSuperview()
        }
    }

    private func setupPageView() {
        pageViewController = CubePageViewController(transitionStyle: .scroll,
                                                    navigationOrientation: .horizontal)

        pageViewController.dataSource = self
        pageViewController.delegate = self

        pageViewControllers = dummyData.enumerated().map { (index, color) in
            let vc = UIViewController()
            vc.view.backgroundColor = color
            vc.title = "\(index)"

            let lb = UILabel()
            vc.view.addSubview(lb)
            lb.text = vc.title
            lb.snp.makeConstraints { $0.center.equalToSuperview() }
            lb.font = .boldSystemFont(ofSize: 64)

            return vc
        }

        if let firstViewController = pageViewControllers.first {
            pageViewController.setViewControllers(
                [firstViewController],
                direction: .forward,
                animated: false
            )
        }

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        pageViewController.view.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(collectionView.snp.top).offset(-20)
        }
    }

    private func reloadCollectionView() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, UIColor>()
        snapshot.appendSections([0])
        snapshot.appendItems(dummyData)
        dataSource.applySnapshotUsingReloadData(snapshot)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let firstIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: firstIndexPath, animated: false, scrollPosition: [])
        setSelection()
    }

    private func snapSelectedCenter() {
        guard !isUserScrolling else { return }
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        isScrollingInMotion = false
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    private func setSelection() {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }

        let targetViewController = pageViewControllers[indexPath.item]
        pageViewController.setViewControllers([targetViewController], direction: .forward, animated: false)
    }
}

extension PhotoViewerViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        snapSelectedCenter()
        setSelection()
        return false
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath == collectionView.indexPathsForSelectedItems?.first {
            if !isScrollingInMotion {
                return .init(width: 44, height: 44)
            }
        }

        return .init(width: 32, height: 44)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard isUserScrolling else { return }
        isScrollingInMotion = true

        let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        if let closestIndexPath = collectionView.indexPathForItem(at: CGPoint(x: centerX, y: collectionView.bounds.midY)) {
            collectionView.selectItem(at: closestIndexPath, animated: false, scrollPosition: [])
            setSelection()

            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.prepare()
            feedbackGenerator.impactOccurred()
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserScrolling = true
        collectionView.collectionViewLayout.invalidateLayout()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isUserScrolling = false
            snapSelectedCenter()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isUserScrolling = false
        snapSelectedCenter()
    }
}

extension PhotoViewerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewControllers.firstIndex(of: viewController), index > 0 else { return nil }
        return pageViewControllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewControllers.firstIndex(of: viewController), index < pageViewControllers.count - 1 else { return nil }
        return pageViewControllers[index + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers?.first,
           let index = pageViewControllers.firstIndex(of: currentViewController) {
            collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            snapSelectedCenter()
        }
    }
}

#Preview {
    PhotoViewerViewController()
}
