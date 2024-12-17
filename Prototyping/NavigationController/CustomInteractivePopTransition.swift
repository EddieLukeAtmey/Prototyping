//
//  CustomInteractivePopTransition.swift
//
//  Created by Ngoc Dang on 22/11/24.
//

import UIKit

/// The controller: control custom interaction along with the pan gesture (should be able to pan from anywhere in the view)
final class CustomInteractivePopTransition: UIPercentDrivenInteractiveTransition {
    var isInteractive = false
    private var transitionContext: UIViewControllerContextTransitioning?
    let animator = CustomPopAnimator()
    weak var viewController: UIViewController?

    func setup(viewController: UIViewController) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        viewController.view.addGestureRecognizer(panGesture)
        viewController.navigationController?.delegate = self

        self.viewController = viewController
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {

        let percent = gesture.translation(in: gesture.view!).x / gesture.view!.bounds.width

        switch gesture.state {
        case .began:

            isInteractive = true
            viewController?.navigationController?.popViewController(animated: true)

        case .changed:
            update(percent)

        case .ended, .cancelled:
            // Thresholds
            let progressThreshold: CGFloat = 0.5
            let velocityThreshold: CGFloat = 1000

            if percent > progressThreshold || gesture.velocity(in: gesture.view!).x > velocityThreshold {
                finish()
            } else {
                cancel()
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
        return isInteractive ? animator : nil
    }

    func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return self
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
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        let screenWidth = transitionContext.containerView.frame.width
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            fromView.transform = CGAffineTransform(translationX: screenWidth, y: 0)
        } completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

#Preview {
    let root = UIViewController()
    root.title = "root"
    let nav = UINavigationController(rootViewController: root)
    nav.pushViewController(CustomNavigationBackViewController(), animated: false)

    return nav
}

