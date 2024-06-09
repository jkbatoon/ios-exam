//
//  ComponentLabel.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/9/24.
//

import UIKit

public class ComponentLabel: UILabel {
    var topInset: CGFloat = 0
    var bottomInset: CGFloat = 0
    var leftInset: CGFloat = 0
    var rightInset: CGFloat = 0
    
    init(style: FontStyle = .body, color: UIColor = Asset.Colors.text.color, alignment: NSTextAlignment = .left, lineBreakmode: NSLineBreakMode = .byTruncatingTail, retainUppercase: Bool = false, text: String? = nil) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        changeStyle(style: style, color: color, alignment: alignment, lineBreakmode: lineBreakmode, retainUppercase: retainUppercase)

        if #available(iOS 14.0, *) {
            lineBreakStrategy = []
        } else {
            UserDefaults.standard.set(false, forKey: "NSAllowsDefaultLineBreakStrategy")
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func changeStyle(style: FontStyle? = nil, color: UIColor? = nil, alignment: NSTextAlignment = .left, lineBreakmode: NSLineBreakMode = .byTruncatingTail, retainUppercase: Bool = false) {
        if let style = style {
            attribute = style.attributes()
        }
        updateAttributes(color: color, alignment: alignment, lineBreakmode: lineBreakmode, retainUppercase: retainUppercase)
    }

    private func updateAttributes(color: UIColor? = nil, alignment: NSTextAlignment? = nil, lineBreakmode: NSLineBreakMode? = nil, retainUppercase: Bool = false) {
        if var attribute = self.attribute {
            if let color = color {
                attribute.color = color
            }
            if let alignment = alignment {
                attribute.alignment = alignment
            }
            if let lineBreakmode = lineBreakmode {
                attribute.lineBreakmode = lineBreakmode
                self.lineBreakMode = lineBreakmode
                
                switch lineBreakmode {
                case .byWordWrapping,
                        .byCharWrapping:
                    numberOfLines = 0
                default:
                    break
                }
            }
            if attribute.allCaps != retainUppercase {
                attribute.allCaps = retainUppercase
            }
            self.attribute = attribute
        } else {
            if let color = color {
                textColor = color
            }
            if let alignment = alignment {
                textAlignment = alignment
            }
            if let lineBreakmode = lineBreakmode {
                self.lineBreakMode = lineBreakmode
            }
            if retainUppercase, text != nil {
                text = text?.uppercased()
            }
        }
    }

    override public func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override public var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
