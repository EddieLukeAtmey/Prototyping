//
//  CustomInteractivePopTransition.swift
//
//  Created by Ngoc Dang on 22/11/24.
//

import UIKit
import Then

/// The controller: control custom interaction along with the pan gesture (should be able to pan from anywhere in the view)
final class CustomInteractivePopTransition: UIPercentDrivenInteractiveTransition {
    typealias PopAction = ()->[UIViewController]?

    private var isInteractive = false
    private var transitionContext: UIViewControllerContextTransitioning?
    private let animator = CustomPopAnimator()
    private weak var viewController: UIViewController?
    private weak var navigationController: UINavigationController?
    private weak var originalNavigationDelegate: UINavigationControllerDelegate?

    private var customPopAction: PopAction?
    private var tempPopViewControllers: [UIViewController]?

    func setup(viewController: UIViewController, useEdgeGesture: Bool = false, customPopAction: PopAction? = nil) {
        let backGesture: UIGestureRecognizer
        if useEdgeGesture {
            let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            edgeGesture.edges = .left
            backGesture = edgeGesture
        } else {
            backGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        }
        viewController.view.addGestureRecognizer(backGesture)

        navigationController = viewController.navigationController
        originalNavigationDelegate = navigationController?.delegate
        self.viewController = viewController

        self.customPopAction = customPopAction
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {

        let percent = gesture.translation(in: gesture.view!).x / gesture.view!.bounds.width
        switch gesture.state {
        case .began:

            isInteractive = true
            navigationController?.delegate = self

            if let customPopAction {
                tempPopViewControllers = customPopAction()
            } else {
                navigationController?.popViewController(animated: true)
            }

        case .changed:
            update(percent)

        case .ended, .cancelled:

            isInteractive = false
            navigationController?.delegate = originalNavigationDelegate
            defer { tempPopViewControllers = nil }

            // Thresholds
            let progressThreshold: CGFloat = 0.5
            let velocityThreshold: CGFloat = 1000

            if percent > progressThreshold || gesture.velocity(in: gesture.view!).x > velocityThreshold {
                finish()
            } else {
                cancel()

                if let viewController, let navigationController  {
                    if let tempPopViewControllers {
                        navigationController.viewControllers.append(contentsOf: tempPopViewControllers)
                    }

                    originalNavigationDelegate?.navigationController?(navigationController, didShow: viewController, animated: true)
                }
            }

        default:
            break
        }
    }
}

extension CustomInteractivePopTransition: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return isInteractive ? animator :
        originalNavigationDelegate?.navigationController?(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
    }

    func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return isInteractive ? self :
        originalNavigationDelegate?.navigationController?(navigationController, interactionControllerFor: animationController)
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard originalNavigationDelegate !== navigationController.delegate else { return }
        originalNavigationDelegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard originalNavigationDelegate !== navigationController.delegate else { return }
        originalNavigationDelegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
    }
}

extension CustomInteractivePopTransition: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

/// The animator: animate the navigation back transitioning
final class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else { return }

        transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
        
        let screenWidth = transitionContext.containerView.frame.width
        toView.transform = .init(translationX: -screenWidth * 0.2, y: 0)

        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            fromView.transform = .init(translationX: screenWidth, y: 0)
            toView.transform = .identity
        } completion: { finished in
            if transitionContext.transitionWasCancelled {
                fromView.transform = .identity
                toView.transform = .identity
            }

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

#Preview {

    let root = UIViewController().then { $0.view.backgroundColor = .blue.withAlphaComponent(0.3) }
    let nav = UINavigationController(rootViewController: root)

    nav.pushViewController(UIViewController().then { $0.view.backgroundColor = .red },
                           animated: false)
    nav.pushViewController(UIViewController().then { $0.view.backgroundColor = .blue },
                           animated: false)
    nav.pushViewController(CustomNavigationBackViewController(), animated: false)


    return nav
}

