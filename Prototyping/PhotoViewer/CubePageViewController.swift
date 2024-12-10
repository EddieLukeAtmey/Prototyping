//
//  CubePageViewController.swift
//  Prototyping
//
//  Created by Ngoc Dang on 9/12/24.
//
//  Refer: https://github.com/oyvinddd/ohcubeview/blob/master/OHCubeView/OHCubeView.swift

import UIKit

final class CubePageViewController: UIPageViewController, UIScrollViewDelegate {
    private let maxAngle: CGFloat = 60

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
    }

    private func setupScrollView() {
        (view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView)?.delegate = self
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let xOffset = scrollView.contentOffset.x
        let svWidth = scrollView.frame.width
        let childViews = scrollView.subviews

        if xOffset == svWidth {
            // After pageview scroll a page, it reset the offset
            childViews.forEach { $0.layer.transform = CATransform3DIdentity }
            return
        }
        var deg = (maxAngle / view.bounds.size.width) * xOffset

        for (index, view) in childViews.enumerated() {
            deg = index == 0 ? deg : deg - maxAngle
            let rad = deg * CGFloat(Double.pi / 180)

            var transform = CATransform3DIdentity
            transform.m34 = 1 / 500
            transform = CATransform3DRotate(transform, rad, 0, 1, 0)

            view.layer.transform = transform
            let x = xOffset / svWidth > CGFloat(index) ? 1.0 : 0.0
            setAnchorPoint(CGPoint(x: x, y: 0.5), forView: view)
//            applyShadowForView(view, index: index)
        }
    }

    fileprivate func setAnchorPoint(_ anchorPoint: CGPoint, forView view: UIView) {

        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)

        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)

        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
}

#Preview {
    PhotoViewerViewController()
}
