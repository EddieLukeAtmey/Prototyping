//
//  CustomToastView.swift
//  Outfitted
//
//  Created by Leticia Rodriguez on 3/10/21.
//

import UIKit

public class CustomToastView: UIView {
    public static let toastViewAccIdentifier = "CustomToastView_Accessibility_Identifier"

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var toastMessageLabel: UILabel!
    @IBOutlet private weak var actionLabel: UILabel!
    @IBOutlet private weak var leftIconImageView: UIImageView!
    @IBOutlet weak var rightIconButton: UIButton!
    
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    var toastTappedNotification: (() -> ())?
//    var actionTappedNotification: () -> () = {}
//    var actionRightTappedNotification: () -> () = {}
    private var toastData: ToastData?
    public var constraint: NSLayoutConstraint?
    public var viewController: UIViewController?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    private func setUI() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(toastTapped))
        containerView.addGestureRecognizer(gesture)
    }

    func configToast(data: ToastData) {
        if let cornerRadius = data.cornerRadius {
            containerView.layer.cornerRadius = cornerRadius
        } else {
            containerView.layer.cornerRadius = data.toastHeight / 2
        }
        
        containerView.backgroundColor = data.backgroundColor
        toastMessageLabel.numberOfLines = 0
        toastMessageLabel.textColor = data.textColor

        toastMessageLabel.textAlignment = data.textAlignment
        
        actionLabel.textColor = data.actionTextColor
        actionLabel.text = data.actionText
        actionLabel.font = data.actionFont
        
        if let attributeText = data.attributedText {
            toastMessageLabel.attributedText = attributeText
        } else {
            toastMessageLabel.font = data.font
            toastMessageLabel.text = data.title
        }
        
        if let leftIconImage = data.leftIconImage {
            leftIconImageView.image = leftIconImage
        }
        
        leftIconImageView.isHidden = data.leftIconImage == nil
        
        leftIconImageView.contentMode = data.leftIconImageContentMode
        
        if let rightIconImage = data.rightIconImage {
            rightIconButton.setImage(rightIconImage, for: .normal)
            rightIconButton.setImage(rightIconImage, for: .selected)
        }
        
        rightIconButton.isHidden = data.rightIconImage == nil
        
        rightIconButton.contentMode = data.leftIconImageContentMode
        
        if let rightActionText = data.actionText {
            actionLabel.text = rightActionText
            toastMessageLabel.textAlignment = .left
            actionLabel.isUserInteractionEnabled = true
        }
        actionLabel.isHidden = data.actionText == nil
        
        leftIconImageView.translatesAutoresizingMaskIntoConstraints = false
        imageWidthConstraint.constant = data.imageWidth
        
        toastData = data
    }
    
    @objc private func toastTapped() {
        toastTappedNotification?()
    }
}
