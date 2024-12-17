//
//  Toast.swift
//  CustomToastView-swift
//
//  Created by Leticia Rodriguez on 5/31/21.
//
import UIKit
import SwiftMessages

public enum AnimationType {
    case bottomToTop
    case topToBottom
    case leftToRight
    case rightToLeft
    case fadeIn
    case fadeOut
}

public class Toast {
    
    var data: ToastData = ToastData()
    
    private init(data: ToastData) {
        self.data = data
    }
    
    @MainActor @discardableResult
    public func show(on viewController: UIViewController,
                     completion: @escaping (CustomToastView) -> () = {_ in},
                     actionCompletion: @escaping () -> () = {}) -> Any? {
//        return CustomToastView.showToast(with: data, viewController: viewController, completion: { toast in
//            completion(toast)
//        }, actionCompletion: {
//            actionCompletion()
//        })

        guard let customToastView = Bundle.main.loadNibNamed(CustomToastView.className, owner: nil, options: nil)?.first as? CustomToastView else {
            // xib not loaded, or it's top view is of the wrong type
            return nil
        }

        customToastView.toastTappedNotification = {
            completion(customToastView)
        }

        customToastView.translatesAutoresizingMaskIntoConstraints = false
        customToastView.configToast(data: data)
        customToastView.accessibilityIdentifier = CustomToastView.toastViewAccIdentifier

        let animator = TopBottomAnimation(style: .top)
        animator.showDuration = 0.5
        animator.hideDuration = 0.5
        animator.springDamping = 0.6
        let presentationStyle = SwiftMessages.PresentationStyle.custom(animator: animator)

        var config = SwiftMessages.defaultConfig
        config.duration = .forever //.seconds(seconds: 3)
        config.presentationStyle = presentationStyle
        config.ignoreDuplicates = false
        config.presentationContext = .window(windowLevel: .alert)

        SwiftMessages.show(view: customToastView)
        SwiftMessages().show(config: config, view: customToastView)

        return customToastView
    }

    public class Builder {
        
        public init() {
            
        }
        
        private var data: ToastData = ToastData()
        
        /// Show Toast right action
        public func rightActionText(_ rightActionText: String) -> Builder {
            data.actionText = rightActionText
            return self
        }
        
        public func textAlignment(_ textAlignment: NSTextAlignment) -> Builder {
            data.textAlignment = textAlignment
            return self
        }
        
        public func showLeftIcon(_ image: UIImage?) -> Builder {
            data.leftIconImage = image
            return self
        }
        
        public func letIconContentMode(_ letIconContentMode: UIView.ContentMode) -> Builder {
            data.leftIconImageContentMode = letIconContentMode
            return self
        }
       
        public func showRightIcon(_ image: UIImage?) -> Builder {
            data.rightIconImage = image
            return self
        }
        
        public func rightIconContentMode(_ letIconContentMode: UIView.ContentMode) -> Builder {
            data.rightIconImageContentMode = letIconContentMode
            return self
        }
        
        public func toastHeight(_ toastHeight: CGFloat) -> Builder {
            data.toastHeight = toastHeight
            return self
        }
        
        /// This property allows you to change the lateral margins of your toast.
        /// If you increase this value the width of the toast will decrease.
        public func sideDistance(_ sideDistance: CGFloat) -> Builder {
            data.sideDistance = sideDistance
            return self
        }
        
        public func verticalPosition(_ verticalPosition: CGFloat) -> Builder {
            data.verticalPosition = verticalPosition
            return self
        }
        
        public func cornerRadius(_ cornerRadius: CGFloat) -> Builder {
            data.cornerRadius = cornerRadius
            return self
        }
        
        public func timeDismissal(_ timeDismissal: Double) -> Builder {
            data.timeDismissal = timeDismissal
            return self
        }
        
        /// shouldDismissAfterPresenting is false by default
        public func shouldDismissAfterPresenting(_ shouldDismissAfterPresenting: Bool) -> Builder {
            data.shouldDismissAfterPresenting = shouldDismissAfterPresenting
            return self
        }
        
        public func orientation(_ orientation: AnimationType) -> Builder {
            data.orientation = orientation
            return self
        }
        
        /// Font of the message string of the toast
        public func font(_ font: UIFont) -> Builder {
            data.font = font
            return self
        }
        
        /// Color of the message string of the toast
        public func textColor(_ textColor: UIColor) -> Builder {
            data.textColor = textColor
            return self
        }
        
        /// BackgroundColor of the toast
        public func backgroundColor(_ backgroundColor: UIColor) -> Builder {
            data.backgroundColor = backgroundColor
            return self
        }
        
        /// Title message of the Toast -> By default is "Hello! I'm a toast message!"
        public func title(_ title: String) -> Builder {
            data.title = title
            return self
        }
        
        /// Color of the action string  of the toast
        public func actionTextColor(_ actionTextColor: UIColor) -> Builder {
            data.actionTextColor = actionTextColor
            return self
        }
        
        /// Text of the action  of the toast
        public func actionText(_ actionText: String) -> Builder {
            data.actionText = actionText
            return self
        }
        
        /// Font of the action  of the toast
        public func actionFont(_ actionFont: UIFont) -> Builder {
            data.actionFont = actionFont
            return self
        }
        
        public func build() -> Toast {
            return Toast(data: data)
        }
        
        /// Title message of the Toast -> By default is "Hello! I'm a toast message!"
        public func titleAttributedText(_ attributedText: NSAttributedString) -> Builder {
            data.attributedText = attributedText
            return self
        }
        
        public func imageWidth(_ height: CGFloat) -> Builder {
            data.imageWidth = height
            return self
        }
    }
}

public extension Toast {
    @MainActor
    static func showUnleashFeatureDisabled(on viewController: UIViewController) {
        let title = "Tính năng bạn chọn đang được bảo trì"
        let subtitle = "Bạn vui lòng quay lại sau"

        let attributeMessage = NSMutableAttributedString()
        attributeMessage.append(.init(string: title, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black,
                                                                  .font: UIFont.boldSystemFont(ofSize: 16)]))
        attributeMessage.append(.init(string: "\n"))
        attributeMessage.append(.init(string: subtitle, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray,
                                                                     .font: UIFont.systemFont(ofSize: 12)]))

        Toast.Builder()
            .backgroundColor(.black.withAlphaComponent(0.3))
            .showLeftIcon(UIImage(systemName: "checkmark.circle.fill"))
            .titleAttributedText(attributeMessage)
            .textAlignment(.left)
            .orientation(.topToBottom)
            .cornerRadius(8)
            .imageWidth(40)
            .build()
            .show(on: viewController)
//            .show(on: viewController) { $0.hide() }
    }
}
