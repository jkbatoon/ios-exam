//
//  UIView.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    class func activate(_ constraints: [NSLayoutConstraint], priority: UILayoutPriority) {
        for constraint in constraints {
            constraint.priority = priority
            constraint.isActive = true
        }
    }
    
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = self
        constraint.priority = priority
        return constraint
    }

    func activate(_ constraints: [NSLayoutConstraint], priority: UILayoutPriority) {
        for constraint in constraints {
            constraint.withPriority(priority).isActive = true
        }
    }
}

public extension UIView {
    @discardableResult
    func usingAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false

        return self
    }

    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    func removeSubviews() {
        for sub in subviews {
            sub.removeFromSuperview()
        }
    }
    
    func removeAllConstraints() {
           var _superview = self.superview
           
           while let superview = _superview {
               for constraint in superview.constraints {
                   
                   if let first = constraint.firstItem as? UIView, first == self {
                       superview.removeConstraint(constraint)
                   }
                   
                   if let second = constraint.secondItem as? UIView, second == self {
                       superview.removeConstraint(constraint)
                   }
               }
               
               _superview = superview.superview
           }
           
           self.removeConstraints(self.constraints)
       }

    @discardableResult
    func addBorder(edges: UIRectEdge,
                   color: UIColor,
                   thickness: CGFloat = 1.0,
                   insets: UIEdgeInsets = .zero) -> [UIView] {

        var borders = [UIView]()

        func border() -> UIView {
            let border = UIView(frame: .zero)
            border.translatesAutoresizingMaskIntoConstraints = false
            border.backgroundColor = color
            return border
        }

        if edges.contains(.top) || edges.contains(.all) {
            let border = border()
            addSubview(border)
            NSLayoutConstraint.activate([
                border.heightAnchor.constraint(equalToConstant: thickness),
                border.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
                border.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
                border.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right)
            ])
            borders.append(border)
        }

        if edges.contains(.left) || edges.contains(.all) {
            let border = border()
            addSubview(border)
            NSLayoutConstraint.activate([
                border.widthAnchor.constraint(equalToConstant: thickness),
                border.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
                border.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
                border.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left)
            ])
            borders.append(border)
        }

        if edges.contains(.right) || edges.contains(.all) {
            let border = border()
            addSubview(border)
            NSLayoutConstraint.activate([
                border.widthAnchor.constraint(equalToConstant: thickness),
                border.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
                border.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
                border.rightAnchor.constraint(equalTo: rightAnchor, constant: insets.right)
            ])
            borders.append(border)
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            let border = border()
            addSubview(border)
            NSLayoutConstraint.activate([
                border.heightAnchor.constraint(equalToConstant: thickness),
                border.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
                border.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right),
                border.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
            ])
            borders.append(border)
        }

        return borders
    }

}

private let referenceSize = CGSize(width: 390, height: 844)

extension UIView {
    func topAnchor(equalTo anchor: NSLayoutYAxisAnchor,
                   constant: CGFloat = 0) -> NSLayoutConstraint {
        self.topAnchor.constraint(equalTo: anchor, constant: adaptiveHeight(constant))
    }

    func topAnchor(greaterThanOrEqualTo anchor: NSLayoutYAxisAnchor,
                   constant: CGFloat = 0) -> NSLayoutConstraint {
        self.topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: adaptiveHeight(constant))
    }

    func bottomAnchor(equalTo anchor: NSLayoutYAxisAnchor,
                      constant: CGFloat = 0) -> NSLayoutConstraint {
        self.bottomAnchor.constraint(equalTo: anchor, constant: adaptiveHeight(constant * -1))
    }

    func bottomAnchor(lessThanOrEqualTo anchor: NSLayoutYAxisAnchor,
                      constant: CGFloat = 0) -> NSLayoutConstraint {
        self.bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: adaptiveHeight(constant * -1))
    }

    func bottomAnchor(greaterThanOrEqualTo anchor: NSLayoutYAxisAnchor,
                      constant: CGFloat = 0) -> NSLayoutConstraint {
        self.bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: adaptiveHeight(constant * -1))
    }

    func leadingAnchor(equalTo anchor: NSLayoutXAxisAnchor,
                       constant: CGFloat = 0) -> NSLayoutConstraint {
        self.leadingAnchor.constraint(equalTo: anchor, constant: adaptiveWidth(constant))
    }

    func leadingAnchor(greaterThanOrEqualTo anchor: NSLayoutXAxisAnchor,
                       constant: CGFloat = 0) -> NSLayoutConstraint {
        self.leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: adaptiveWidth(constant))
    }

    func trailingAnchor(equalTo anchor: NSLayoutXAxisAnchor,
                        constant: CGFloat = 0) -> NSLayoutConstraint {
        self.trailingAnchor.constraint(equalTo: anchor, constant: adaptiveWidth(constant * -1))
    }

    func trailingAnchor(lessThanOrEqualTo anchor: NSLayoutXAxisAnchor,
                        constant: CGFloat = 0) -> NSLayoutConstraint {
        self.trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: adaptiveWidth(constant * -1))
    }

    func heightAnchor(equalTo anchor: NSLayoutDimension) -> NSLayoutConstraint {
        self.heightAnchor.constraint(equalTo: anchor)
    }

    func heightAnchor(equalTo anchor: NSLayoutDimension, multiplier: CGFloat) -> NSLayoutConstraint {
        self.heightAnchor.constraint(equalTo: anchor, multiplier: multiplier)
    }

    func heightAnchor(equalTo constant: CGFloat) -> NSLayoutConstraint {
        self.heightAnchor.constraint(equalToConstant: adaptiveHeight(constant))
    }

    func heightAnchor(greaterThanOrEqualTo constant: CGFloat) -> NSLayoutConstraint {
        self.heightAnchor.constraint(equalToConstant: adaptiveHeight(constant))
    }

    func widthAnchor(equalTo constant: CGFloat) -> NSLayoutConstraint {
        self.widthAnchor.constraint(equalToConstant: adaptiveWidth(constant))
    }

    func widthAnchor(equalTo constant: NSLayoutDimension) -> NSLayoutConstraint {
        self.widthAnchor.constraint(equalTo: constant)
    }

    func widthAnchor(equalTo anchor: NSLayoutDimension, multiplier: CGFloat) -> NSLayoutConstraint {
        self.widthAnchor.constraint(equalTo: anchor, multiplier: multiplier)
    }

    func widthAnchor(greaterThanOrEqualTo anchor: NSLayoutDimension, multiplier: CGFloat) -> NSLayoutConstraint {
        self.widthAnchor.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier)
    }

    func widthAnchor(lessThanOrEqualTo constant: CGFloat) -> NSLayoutConstraint {
        self.widthAnchor.constraint(lessThanOrEqualToConstant: adaptiveWidth(constant))
    }

    func widthAnchor(greaterThanOrEqualTo constant: CGFloat) -> NSLayoutConstraint {
        self.widthAnchor.constraint(greaterThanOrEqualToConstant: adaptiveWidth(constant))
    }

    func centerXAnchor(equalTo xAxisAnchor: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
        self.centerXAnchor.constraint(equalTo: xAxisAnchor)
    }

    func centerXAnchor(equalTo xAxisAnchor: NSLayoutXAxisAnchor, constant: CGFloat) -> NSLayoutConstraint {
        self.centerXAnchor.constraint(equalTo: xAxisAnchor, constant: constant)
    }

    func centerYAnchor(equalTo yAxisAnchor: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
        self.centerYAnchor.constraint(equalTo: yAxisAnchor)
    }

    func centerYAnchor(equalTo yAxisAnchor: NSLayoutYAxisAnchor, constant: CGFloat) -> NSLayoutConstraint {
        self.centerYAnchor.constraint(equalTo: yAxisAnchor, constant: adaptiveHeight(constant))
    }

    func leftAnchor(equalTo anchor: NSLayoutXAxisAnchor,
                    constant: CGFloat = 0) -> NSLayoutConstraint {
        self.leftAnchor.constraint(equalTo: anchor, constant: adaptiveWidth(constant))
    }

    func rightAnchor(equalTo anchor: NSLayoutXAxisAnchor,
                     constant: CGFloat = 0) -> NSLayoutConstraint {
        self.rightAnchor.constraint(equalTo: anchor, constant: adaptiveWidth(constant))
    }

    func adaptiveHeight(_ height: CGFloat) -> CGFloat {
        let screen = UIScreen.main.bounds
        return screen.size.height * height / referenceSize.height
    }

    func adaptiveWidth(_ width: CGFloat) -> CGFloat {
        let screen = UIScreen.main.bounds
        return screen.size.width * width / referenceSize.width
    }
}
