//
//  FontStyle.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/9/24.
//

import UIKit

protocol FontStyleRenderer {
    var style: FontStyle? { get set }
    var attribute: FontStyleAttribute? { get set }
}

enum Font {
    enum Inter: String {
        case regular = "Inter-Regular"
        case medium = "Inter-Medium"
        case bold = "Inter-Bold"
        case semibold = "Inter-SemiBold"

        func getUIFont(_ size: CGFloat = 16) -> UIFont {
            let fontFeatures = [[UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                                 UIFontDescriptor.FeatureKey.typeIdentifier: kProportionalNumbersSelector],
                                [UIFontDescriptor.FeatureKey.featureIdentifier: kNumberCaseType,
                                 UIFontDescriptor.FeatureKey.typeIdentifier: kUpperCaseNumbersSelector]]
            var fontDescriptor = UIFontDescriptor(name: self.rawValue, size: size)
            fontDescriptor = fontDescriptor.addingAttributes([UIFontDescriptor.AttributeName.featureSettings: fontFeatures])
            return UIFont(descriptor: fontDescriptor, size: size)
        }
        
        private func getFontNames() {
            for family in UIFont.familyNames.sorted() {
                let names = UIFont.fontNames(forFamilyName: family)
                print("Family: \(family) Font names: \(names)")
            }
        }
    }
}

enum FontStyle: String, CaseIterable {
    case heading1
    case heading2
    case heading3
    case title1
    case title2
    case label1
    case label2
    case body
    case smallText
    case smallTextSemi

    var font: UIFont {
        attributes().font
    }

    func attributes() -> FontStyleAttribute {
        var style = FontStyleAttribute()
        switch self {
        case .heading1:
            style.font = Font.Inter.semibold.getUIFont(20)
        case .heading2:
            style.font = Font.Inter.semibold.getUIFont(18)
        case .heading3:
            style.font = Font.Inter.regular.getUIFont(16)
        case .title1:
            style.font = Font.Inter.bold.getUIFont(16)
        case .title2:
            style.font = Font.Inter.bold.getUIFont(14)
        case .label1:
            style.font = Font.Inter.semibold.getUIFont(14)
        case .label2:
            style.font = Font.Inter.semibold.getUIFont(12)
        case .body:
            style.font = Font.Inter.regular.getUIFont(12)
        case .smallText:
            style.font = Font.Inter.regular.getUIFont(10)
        case .smallTextSemi:
            style.font = Font.Inter.semibold.getUIFont(10)
        }
        return style
    }
}

struct FontStyleAttribute {
    var font = Font.Inter.regular.getUIFont(16)
    var lineHeight: CGFloat = 0.0
    var characterSpacing: CGFloat = 0.0 // kerning
    var color = Asset.Colors.text.color
    var allCaps = false
    var alignment: NSTextAlignment = .left
    var underlined = false
    var icon: UIImage?
    var iconHeight: CGFloat = 0.0
    var baseline: CGFloat = 0.0
    var minimumLineHeight: CGFloat = 0.0
    var lineHeightMultiple: CGFloat = 0.0
    var lineBreakmode: NSLineBreakMode = .byTruncatingTail

    func createAttributedString(_ string: String) -> NSMutableAttributedString {
        let range = NSRange(location: 0, length: string.utf16.count)
        var attributedString = NSMutableAttributedString(string: allCaps ? string.uppercased(): string)
        attributedString.addAttributes(attributes(), range: range)
        if let image = icon, iconHeight > 0.0 {
            let attachment = NSTextAttachment()
            attachment.image = image
            if let image = attachment.image {
                let yOffset = (font.capHeight - iconHeight) / 2.0
                let ratio = image.size.width / image.size.height

                if alignment == .left {
                    attachment.bounds = CGRect(x: 0,
                                               y: yOffset,
                                               width: image.size.width * ratio,
                                               height: image.size.height).integral
                } else {
                    attachment.bounds = CGRect(x: 0,
                                               y: 0,
                                               width: image.size.width * ratio,
                                               height: image.size.height).integral
                }
            }

            let attributedAttachment = NSAttributedString(attachment: attachment)
            let space = NSAttributedString(string: " ")

            if alignment == .left {
                let attributed = NSMutableAttributedString(attributedString: attributedAttachment)
                attributed.append(space)
                attributed.append(attributedString)
                attributedString = attributed
            } else {
                let attributed = NSMutableAttributedString(attributedString: attributedString)
                attributed.append(space)
                attributed.append(space)
                attributed.append(attributedAttachment)
                attributed.append(space)
                attributedString = attributed
            }
        }
        return attributedString
    }

    func attributes() -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakmode
        paragraphStyle.minimumLineHeight = minimumLineHeight
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        let fontSize = font.pointSize
        if lineHeight != 0.0 {
            if lineHeight < fontSize {
                paragraphStyle.lineSpacing = lineHeight - fontSize
                paragraphStyle.maximumLineHeight = max(lineHeight - paragraphStyle.lineSpacing, 0.0)
            } else {
                paragraphStyle.lineSpacing = lineHeight - fontSize
            }
        }

        paragraphStyle.alignment = alignment
        return [NSAttributedString.Key.font: font,
                NSAttributedString.Key.underlineStyle: underlined ? NSUnderlineStyle.thick.rawValue: 0,
                NSAttributedString.Key.baselineOffset: baseline,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.kern: characterSpacing]
    }
}
