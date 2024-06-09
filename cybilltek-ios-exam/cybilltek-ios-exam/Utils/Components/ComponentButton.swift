//
//  ComponentButton.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/9/24.
//

import Foundation
import UIKit

open class ComponentButton: UIButton {

   public enum ButtonStyle {
       case primary(text: String)
       case secondary(text: String)
       case image(image: UIImage)
       case none
   }

    var buttonStyle: ButtonStyle = .primary(text: "") {
        didSet {
            setUp()
        }
    }

    override open var isHighlighted: Bool {
        didSet {
            switch buttonStyle {
            // TODO: Set highlighted state once we already have in UI Toolkit
            case .primary:
                let color = Asset.Colors.themeSecondary.color
                backgroundColor = isHighlighted ? color.withAlphaComponent(0.5) : color
            case .secondary:
                backgroundColor = .clear
            default:
                break
            }
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
            switch buttonStyle {
            case .primary:
                let color = Asset.Colors.themeSecondary.color
                backgroundColor = isEnabled ? color : Asset.Colors.disable.color
            default:
                break
            }
        }
    }

    init(style: ButtonStyle) {
        super.init(frame: CGRect.zero)
        self.buttonStyle = style
        setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    fileprivate func setUp() {
        
        var attribute = FontStyle.label1.attributes()
        attribute.lineHeight = 0
        attribute.baseline = 0
        
        var attributeHighlighted = FontStyle.label1.attributes()
        attributeHighlighted.lineHeight = 0
        attributeHighlighted.baseline = 0

        layer.cornerRadius = UIView().adaptiveHeight(4)

        clipsToBounds = true
        
        switch buttonStyle {
        case .primary(let text):
            setTitle(text, for: .normal)
            backgroundColor = Asset.Colors.themeSecondary.color
            attribute.color = Asset.Colors.themeMain.color
            attributeHighlighted.color = Asset.Colors.themeMain.color
            
        case .secondary(let text):
            setTitle(text, for: .normal)
            backgroundColor = Asset.Colors.themeMain.color
            layer.borderColor = Asset.Colors.themeSecondary.color.cgColor
            layer.borderWidth = 1
            attribute.color = Asset.Colors.themeSecondary.color
            attributeHighlighted.color = Asset.Colors.themeSecondary.color
            
        case .none:
            attributes = [:]
            backgroundColor = .clear
        case .image(let image):
            layer.cornerRadius = 0
            setUpIconButton(image: image)
        }
        
        attributes = [AttributeKeys.normal: attribute,
                      AttributeKeys.disabled: attribute,
                      AttributeKeys.highlighted: attributeHighlighted]
        
        setNeedsLayout()
    }
    
    fileprivate func setUpIconButton(image: UIImage) {
        attributes = [:]
        setTitle(nil, for: .normal)
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
        
        imageView?.contentMode = .scaleAspectFit
        attributes = [:]
        backgroundColor = .clear
    }
    
    fileprivate func setUpTextButton(title: String, color: UIColor? = nil) {
        setTitle(title, for: .normal)
        var attribute = FontStyle.label1.attributes()
        attribute.lineHeight = 0
        attribute.color = color ?? Asset.Colors.themeSecondary.color
        var highlightAttribute = attribute
        highlightAttribute.color = color ?? Asset.Colors.themeSecondary.color.withAlphaComponent(0.5)
        attributes = [AttributeKeys.normal: attribute,
                      AttributeKeys.highlighted: highlightAttribute]
        backgroundColor = .clear
        
        setNeedsLayout()
    }

}
