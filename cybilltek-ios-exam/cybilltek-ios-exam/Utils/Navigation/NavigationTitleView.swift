//
//  NavigationTitleView.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/9/24.
//

import UIKit

class NavigationTitleView: UIView {

    var title: ComponentLabel = {
        ComponentLabel(
            style: .title1,
            color: Asset.Colors.themeMain.color).usingAutoLayout()
    }()
    
    // MARK: - Properties
    var titleHorizontalConstraints: [NSLayoutConstraint] = []
    var titleWithIconHorizontalConstraints: [NSLayoutConstraint] = []
    
    // MARK: - View lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleHorizontalConstraints = [
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]

        // Setup this view
        setupSubviews()
        setupConstraints()

        self.title.sizeToFit()
    }
    
    convenience init(title: String, titleColor: UIColor? = nil) {
        
        self.init(frame: CGRect.zero)

        self.title.text = title
        

        if let titleColor = titleColor {
            self.title.attribute?.color = titleColor
        }
        
        setupConstraints()
        
        // This allows the label to fill out the space after the constraints are set
        // Without this call the size of this view is zero

        self.title.sizeToFit()
    }
    
    convenience init(title: String, icon: UIImage?, color: UIColor) {
        
        self.init(frame: CGRect.zero)
        
        self.title.text = title
        self.title.textColor = color
                
        setupConstraints()
        
        // This allows the label to fill out the space after the constraints are set
        // Without this call the size of this view is zero

        self.title.sizeToFit()
    }
    
    // MARK: - Private methods
    
    private func setupSubviews() {
        
        // Setup Subviews with constraints and anchors
        self.addSubview(title)
        
        self.shouldGroupAccessibilityChildren = true
        self.accessibilityElementsHidden = false
        
        self.title.accessibilityLabel = self.title.text
        self.title.isAccessibilityElement = true
        self.title.accessibilityElementsHidden = false
        self.title.accessibilityTraits = .staticText
        
        self.accessibilityElements = [self.title]
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.deactivate(titleWithIconHorizontalConstraints)
        NSLayoutConstraint.activate(titleHorizontalConstraints)
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
