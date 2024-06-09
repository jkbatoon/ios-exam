//
//  UILabel.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/9/24.
//

import RxCocoa
import RxSwift
import UIKit

var styleAssociatedObject: UInt = 0
var attributeAssociatedObject: UInt = 1

extension UILabel: FontStyleRenderer {
    var style: FontStyle? {
        get {
            if let associated = objc_getAssociatedObject(self, &styleAssociatedObject) as? FontStyle {
                return associated
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self,
                                     &styleAssociatedObject,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.attribute = newValue?.attributes()
        }
    }

    var attribute: FontStyleAttribute? {
        get {
            objc_getAssociatedObject(self, &attributeAssociatedObject) as? FontStyleAttribute
        }
        set {
            objc_setAssociatedObject(self,
                                     &attributeAssociatedObject,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateStyle()
        }
    }

    convenience init(style: FontStyle) {
        self.init(attribute: style.attributes())
        self.style = style
    }

    convenience init(attribute: FontStyleAttribute) {
        self.init(frame: CGRect.zero)
        self.attribute = attribute
    }

    static func setupSwizzle() {
        swizzleMethod(self, fromMethod: #selector(setter: UILabel.text),
                      toMethod: #selector(UILabel.setStyledText))
        swizzleMethod(self, fromMethod: #selector(setter: UILabel.lineBreakMode),
                      toMethod: #selector(UILabel.setStyleLineBreakMode))
    }

    @objc func setStyledText(_ text: String) {
        // This is not an infinate loop because setStyledText is swizzled to the setter of self.text
        self.setStyledText(text)
        updateStyle()
    }

    @objc func setStyleLineBreakMode(_ lineBreakMode: NSLineBreakMode) {
        self.setStyleLineBreakMode(lineBreakMode)
        updateStyle()
    }

    private func updateStyle() {
        if var styleAttributes = attribute, let contentText = text {
            if styleAttributes.lineBreakmode == .byWordWrapping || styleAttributes.lineBreakmode == .byCharWrapping {
                numberOfLines = 0
            }
            styleAttributes.lineHeight = numberOfLines == 1 ? 0: styleAttributes.lineHeight
            styleAttributes.lineBreakmode = self.lineBreakMode
            attributedText = styleAttributes.createAttributedString(contentText)
        }
    }
    
    func setNewColor(color: UIColor) {
        var newAttribute = self.attribute
        newAttribute?.color = color
        self.attribute = newAttribute
    }
}

extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
}
