//
//  PhotoViewerViewController.swift
//  Prototyping
//
//  Created by Eddie on 4/12/24.
//

import UIKit
import SnapKit
import Then

final class PhotoViewerViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let itemSpacing: CGFloat = 5
    private let selectionAdditionSpacing: CGFloat = 10
    private let itemSize: CGSize = .init(width: 32, height: 44)

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
        .green.withAlphaComponent(0.7),

        .systemPink.withAlphaComponent(0.3),
        .orange.withAlphaComponent(0.2),
        .cyan.withAlphaComponent(0.4),
        .amethyst.withAlphaComponent(0.45)
    ] //.shuffled()

    lazy var dataSource = UICollectionViewDiffableDataSource<Int, UIColor>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
        (collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.className, for: indexPath) as? PhotoCell)?
            .then { $0.configure(with: itemIdentifier, index: indexPath.item) }
    }

    private var isScrollingInMotion = false { didSet {
        photoViewerLayout.isScrollingInMotion = isScrollingInMotion
    }}

    private var isUserScrolling = false
    private let photoViewerLayout = PhotoViewerCollectionViewLayout()

    // PageVC
    private var pageViewController: UIPageViewController!
    private var pageViewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPageView()
        setupCollectionView()
        reloadCollectionView()
    }

    private func setupCollectionView() {

        photoViewerLayout.scrollDirection = .horizontal
        photoViewerLayout.minimumInteritemSpacing = selectionAdditionSpacing
        photoViewerLayout.minimumLineSpacing = itemSpacing
        photoViewerLayout.itemSize = itemSize

        // Ensure first and last items center-align
        let sideInset = (view.bounds.width - itemSize.width) / 2
        photoViewerLayout.sectionInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: photoViewerLayout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.className)
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast // Smooth scrolling
        collectionView.backgroundColor = .clear

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }

        let middleIndicator = UIView()
        middleIndicator.backgroundColor = .black
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
            $0.edges.equalToSuperview()
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

        guard collectionView.indexPathsForSelectedItems?.count == 0 else { return }
        selectItem(at: 0)
    }

    private func snapSelectedCenter(animationDuration: TimeInterval = 0.2) {
        guard !isUserScrolling else { return }
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        isScrollingInMotion = false
        UIView.animate(withDuration: animationDuration) {
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        } completion: {  _ in
            // This fix a bug sometime a cell doesn't render after the animation.
            self.dataSource.apply(self.dataSource.snapshot(), animatingDifferences: false)
        }
    }

    private func selectItem(at index: Int) {

        guard collectionView.indexPathsForSelectedItems?.first?.item != index else { return }

        let direction: UIPageViewController.NavigationDirection
        if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first, selectedIndexPath.item > index {
            direction = .reverse
        } else {
            direction = .forward
        }

        let indexPath = IndexPath(item: index, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        let targetViewController = pageViewControllers[index]
        pageViewController.setViewControllers([targetViewController], direction: direction, animated: true)
    }
}

extension PhotoViewerViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {

        selectItem(at: indexPath.item)
        snapSelectedCenter(animationDuration: 0.35)
        return false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard isUserScrolling else { return }
        isScrollingInMotion = true

        let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        if let closestIndexPath = collectionView.indexPathForItem(at: CGPoint(x: centerX, y: collectionView.bounds.midY)) {
            selectItem(at: closestIndexPath.item)

            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.prepare()
            feedbackGenerator.impactOccurred()
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserScrolling = true
        UIView.animate(withDuration: 0.2) {
            self.isScrollingInMotion = true
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
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
