//
//  ToastData.swift
//  CustomToastView-swift
//
//  Created by Leticia Rodriguez on 5/31/21.
//

import UIKit

public struct ToastData {
    //var type: CustomToastType = .simple
    var font = UIFont.systemFont(ofSize: 14,
                                 weight: .regular)
    var textColor: UIColor = .white
    var backgroundColor: UIColor = .magenta
    var title = "Hello! I'm a toast message!"
    var attributedText: NSAttributedString?
    var actionTextColor: UIColor = .black
    var actionText: String? = nil
    var actionFont = UIFont.systemFont(ofSize: 14,
                                       weight: .regular)
//    var orientation: AnimationType = .bottomToTop
    var leftIconImage: UIImage? = nil
    var rightIconImage: UIImage? = nil
    var toastHeight: CGFloat = 64
    var sideDistance: CGFloat = 16
    var cornerRadius: CGFloat? = nil
    var timeDismissal = 0.5
    var verticalPosition: CGFloat = 0
    var shouldDismissAfterPresenting = true
    var textAlignment: NSTextAlignment = .center
    var leftIconImageContentMode: UIView.ContentMode = .scaleAspectFit
    var rightIconImageContentMode: UIView.ContentMode = .scaleAspectFit
    
    var imageWidth: CGFloat = 24.0
    
    public init() {
        
    }
}
