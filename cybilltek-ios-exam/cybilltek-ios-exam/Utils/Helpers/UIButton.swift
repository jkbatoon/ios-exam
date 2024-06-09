//
//  UIButton.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/9/24.
//

import UIKit

var buttonStyleKey: UInt = 0
var buttonAttributeKey: UInt = 1

enum AttributeKeys {
    static let normal = "normal"
    static let selected = "selected"
    static let highlighted = "highlighted"
    static let disabled = "disabled"

    static func getControlState(stateKey: String) -> UIControl.State? {
        switch stateKey {
        case normal:
            return UIControl.State.normal
        case selected:
            return UIControl.State.selected
        case highlighted:
            return UIControl.State.highlighted
        case disabled:
            return UIControl.State.disabled
        default:
            break
        }
        return nil
    }
}

extension UIButton {
    typealias StyleKeyValues = [String: FontStyle]
    typealias AttributeKeyValues = [String: FontStyleAttribute]

    var styles: StyleKeyValues {
        get {
            if let associated = objc_getAssociatedObject(self, &buttonStyleKey) as? StyleKeyValues {
                return associated
            }
            return [:]
        }
        set {
            objc_setAssociatedObject(self,
                                     &buttonStyleKey,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            newValue.forEach { attributes[$0] = $1.attributes() }
        }
    }

    var attributes: AttributeKeyValues {
        get {
            if let associated = objc_getAssociatedObject(self, &buttonAttributeKey) as? AttributeKeyValues {
                return associated
            }
            return [:]
        }
        set {
            objc_setAssociatedObject(self,
                                     &buttonAttributeKey,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            applyStyle()
        }
    }

    static func setupSwizzle() {
        swizzleMethod(self, fromMethod: #selector(UIButton.setTitle(_:for:)),
                      toMethod: #selector(UIButton.setStyledTitle(_:for:)))
    }

    @objc
    func setStyledTitle(_ title: String?, for: UIControl.State) {
        // This is not an infinate loop because setStyledTitle is swizzled to setTitle
        setStyledTitle(title, for: `for`) // back quotes are used because for is a reserved keyword
        applyStyle()
    }

    func applyStyle() {
        attributes.forEach { key, value in
            if let title = currentTitle, let state = AttributeKeys.getControlState(stateKey: key) {
                var styleAttribute = value
                if let buttonLabel = titleLabel {
                    styleAttribute.lineHeight = buttonLabel.numberOfLines == 1 ? 0 : value.lineHeight
                }
                setAttributedTitle(styleAttribute.createAttributedString(title), for: state)
                // Incase we have a selected state as well we need to specify a highlighted/selected state
                if state == .highlighted {
                    setAttributedTitle(styleAttribute.createAttributedString(title), for: [.highlighted, .selected])
                }
            } else if let state = AttributeKeys.getControlState(stateKey: key) {
                setAttributedTitle(nil, for: state)
                // Incase we have a selected state as well we need to specify a highlighted/selected state
                if state == .highlighted {
                    setAttributedTitle(nil, for: [.highlighted, .selected])
                }
            }
        }
    }
}

extension UIButton {
    func updateImageInsets(imageSize: CGSize, buttonSize: CGSize) {
        let verticalInset = (buttonSize.width - imageSize.width) / 2.0
        let horizontalInset = (buttonSize.height - imageSize.height) / 2.0

        imageEdgeInsets = UIEdgeInsets(top: horizontalInset,
                                       left: verticalInset,
                                       bottom: horizontalInset,
                                       right: verticalInset)
    }

    func addPaddedUnderline(
        padding: CGFloat = 5,
        thickness: CGFloat = 1,
        underlineColor: UIColor? = nil
    ) {
        let v = UIView().usingAutoLayout()
        v.backgroundColor = underlineColor ?? titleLabel?.textColor
        v.isUserInteractionEnabled = false

        addSubview(v)

        if let titleLabel = titleLabel {
            NSLayoutConstraint.activate([
                v.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                v.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                v.bottomAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor, constant: padding),
                v.heightAnchor.constraint(equalToConstant: thickness)
            ])
        }
    }
        
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }

func centerVertically(padding: CGFloat = 6.0) {
        guard
            let imageViewSize = self.imageView?.frame.size,
            let titleLabelSize = self.titleLabel?.frame.size else {
            return
        }
        
        let totalHeight = imageViewSize.height + titleLabelSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageViewSize.height),
            left: 0.0,
            bottom: 0.0,
            right: -titleLabelSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 10.0,
            left: -imageViewSize.width,
            bottom: -(totalHeight - titleLabelSize.height),
            right: 0.0
        )
        
        self.contentEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: titleLabelSize.height,
            right: 0.0
        )
    }
}
