//
//  UIStackView.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/10/24.
//

import UIKit

public extension UIStackView {

    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }

    func removeArrangedSubviews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
