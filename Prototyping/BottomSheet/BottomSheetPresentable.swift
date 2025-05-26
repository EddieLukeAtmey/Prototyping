//  BottomSheetPresentable.swift
//  Prototyping
//
//  Created by Eddie on 19/5/25.
//  

/**
 This is the configuration object for a view controller
 that will be presented using the PanModal transition.

 Usage:
 ```
 extension YourViewController: ABBottomSheetPresentable {
    func shouldRoundTopCorners: Bool { return false }
 }
 ```
 */

import UIKit

public enum BottomSheetHeight: Equatable {

    /**
     Sets the height to be the maximum height (+ topOffset)
     */
    case maxHeight

    /**
     Sets the height to be the max height with a specified top inset.
     - Note: A value of 0 is equivalent to .maxHeight
     */
    case maxHeightWithTopInset(CGFloat)

    /**
     Sets the height to be the specified content height
     */
    case fixed(CGFloat)

    /**
     Sets the height to be the intrinsic content height
     */
    case intrinsicHeight
}

public protocol BottomSheetPresentable: UIViewController {
    /**
     Default value is .intrinsicHeight
     */
    var bottomSheetHeight: BottomSheetHeight { get }

    /**
     Default value is .medium.
     */
    var hapticFeedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle? { get }

    /**
     A flag to determine if dismissal should be initiated when tapping on the dimmed background view.

     Default value is false.
     */
    var allowsTapToDismiss: Bool { get }
}

public extension BottomSheetPresentable {
    /**
     Default value is .intrinsicHeight
     */
    var bottomSheetHeight: BottomSheetHeight { .intrinsicHeight }

    /**
     Default value is .medium.
     */
    var hapticFeedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle? { .medium }

    /**
     A flag to determine if dismissal should be initiated when tapping on the dimmed background view.

     Default value is false.
     */
    var allowsTapToDismiss: Bool { false }
}

public extension BottomSheetPresentable {
    var bottomSheetWrapperViewController: ABBottomSheetWrapperViewController {
        ABBottomSheetWrapperViewController(bottomSheetPresentable: self)
    }
}

public class ABBottomSheetWrapperViewController: UIViewController {

    public required init?(coder: NSCoder) { nil }

    private var bottomSheetPresentable: BottomSheetPresentable?
    private var initialLayoutDone = false
    init(bottomSheetPresentable: BottomSheetPresentable) {
        super.init(nibName: nil, bundle: nil)
        addBottomSheetContent(bottomSheetPresentable)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.presentationController?.containerView?.backgroundColor = .black.withAlphaComponent(0.3)
        }

        hapticFeedbackIfPossible()
        setupTapOutsideToDismiss()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.2) {
            self.presentationController?.containerView?.backgroundColor = nil
        }
    }

    public final override var modalPresentationStyle: UIModalPresentationStyle {
        get { .overCurrentContext }
        set {}
    }

    public final override var modalTransitionStyle: UIModalTransitionStyle {
        get { .coverVertical }
        set {}
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 32
        view.clipsToBounds = true

        guard !initialLayoutDone else { return }
        initialLayoutDone = true

        adjustBottomSheetHeight()
    }

    private func adjustBottomSheetHeight() {
        let screenHeight = UIScreen.main.bounds.height
        let viewHeight: CGFloat

        switch bottomSheetPresentable?.bottomSheetHeight {
        case .maxHeight:
            viewHeight = screenHeight
        case .maxHeightWithTopInset(let topInset):
            viewHeight = screenHeight - topInset
        case .fixed(let contentHeight):
            viewHeight = contentHeight
        case .intrinsicHeight:
            viewHeight = bottomSheetPresentable!.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        default:
            return
        }

        view.frame.size.height = viewHeight
        view.frame.origin.y = screenHeight - view.frame.size.height
    }

    private func addBottomSheetContent(_ viewController: BottomSheetPresentable) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        viewController.didMove(toParent: self)
        bottomSheetPresentable = viewController
    }

    @objc private func keyboardChanged(notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard bottomSheetPresentable?.bottomSheetHeight == .intrinsicHeight else { return }

        let screenHeight = keyboardFrame.minY
        view.frame.origin.y = screenHeight - view.frame.size.height
    }

    private func hapticFeedbackIfPossible() {
        guard let feedbackStyle = bottomSheetPresentable?.hapticFeedbackStyle else { return }
        let feedbackGenerator = UIImpactFeedbackGenerator(style: feedbackStyle)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }

    private func setupTapOutsideToDismiss() {
        guard bottomSheetPresentable?.allowsTapToDismiss == true  else { return }
        guard let outsideView = self.presentationController?.containerView else { return }

        outsideView.gestureRecognizers?.removeAll()
        outsideView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
    }

    @objc private func close() {
        dismiss(animated: true)
    }
}
