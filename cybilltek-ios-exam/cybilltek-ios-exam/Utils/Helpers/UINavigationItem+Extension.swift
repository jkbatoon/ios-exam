//
//  UINavigationItem+Extension.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/9/24.
//

import Foundation
import RxSwift
import UIKit

extension UINavigationItem {
    
    typealias Button = ComponentButton
    
    enum Sizes {
        static let buttonImage = CGSize(width: 24, height: 24)
    }
    
    func addButtons(types: [NavigationButtonType],
                    position: NavigationButtonPositionType,
                    disposeBag: DisposeBag) {
        
        // Setup button appearance
        var buttonItems = [UIBarButtonItem]()
        
        // Set 28px of fixed space multiple button items
        let inBetweenSpacing = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        inBetweenSpacing.width = 2
        
        for (index, type) in types.enumerated() {
            
            if index % 2 == 1 {
                // Add in between spacing
                buttonItems.append(inBetweenSpacing)
            }
            
            let button: Button = {
                
                var buttonStyle = Button.ButtonStyle.none
                var buttonSize = Sizes.buttonImage
                
                if let iconImage = type.menuIcon {
                    buttonStyle = Button.ButtonStyle.image(image: iconImage)
                } else {
//                    switch type {
//                    case .profileAddData:
//                        buttonStyle = Button.ButtonStyle.plainText(title: type.title, color: AppColor.irisDark)
//                    case .buttonWithCustom(_, let color, _):
//                        buttonStyle = Button.ButtonStyle.plainText(title: type.title, color: color)
//
//                    default:
                        buttonStyle = Button.ButtonStyle.primary(text: type.title)
//                    }
                    buttonSize = CGSize(width: 343, height: 42)
                }
                
                let button = Button(style: buttonStyle)
                button.imageView?.contentMode = .scaleAspectFill
                // button.contentHorizontalAlignment = .fill
                // button.contentVerticalAlignment = .fill
                
                // button.contentEdgeInsets = .zero
                button.frame = CGRect(x: 0, y: 0, width: UIView().adaptiveWidth(buttonSize.width), height: UIView().adaptiveWidth(buttonSize.height))
                return button
            }()

            let barButton = UIBarButtonItem(customView: button)
            buttonItems.append(barButton)

            button.accessibilityLabel = ""
            button.accessibilityTraits = .none
            barButton.accessibilityLabel = ""
            barButton.accessibilityTraits = .none
            barButton.shouldGroupAccessibilityChildren = true

            // Setup observables
            
            button.rx.tap
                .subscribe(onNext: {
                    switch type {
                    case .back:
                        NavigationController.getVisibleViewController().popTo(.previous)
                        // prep for firebase analytics
                    case .close:
                        let nav = NavigationController.getVisibleViewController()
                            nav.popTo(.previous)
                    case .backCustom(let action):
                        action.accept(())
                        NavigationController.getVisibleViewController().popTo(.previous)
                    case .actionWithIcon(_, let action):
                        action.accept(())

                    case .buttonWithCustom(_, _, let action):
                        action.accept(())
                    }
                })
                .disposed(by: disposeBag)
        }
        
        // Set left or right edge button spacing
        let buttonEdgeSpacing = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        buttonEdgeSpacing.width = -6
        
        // Add to left or right of navigation bar
        switch position {
        case .left:
            self.leftBarButtonItem = nil
            self.leftBarButtonItems = nil
            self.leftBarButtonItems = [buttonEdgeSpacing]
            self.leftBarButtonItems?.append(contentsOf: buttonItems)
        case .right:
            self.rightBarButtonItem = nil
            self.rightBarButtonItems = nil
            self.rightBarButtonItems = [buttonEdgeSpacing]
            self.rightBarButtonItems?.append(contentsOf: buttonItems)
        }
    }
    
    func removeButtons(at position: NavigationButtonPositionType) {
        
        let buttonEdgeSpacing = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                                target: nil, action: nil)
        buttonEdgeSpacing.width = 0
        switch position {
        case .left:
            self.leftBarButtonItem = nil
            self.leftBarButtonItems = [buttonEdgeSpacing]
        case .right:
            self.rightBarButtonItem = nil
            self.rightBarButtonItems = [buttonEdgeSpacing]
        }
    }
    
    func addCustomViews(views: [UIView], position: NavigationButtonPositionType, disposeBag: DisposeBag) {
        
        // Setup view appearance
        var viewItems = [UIBarButtonItem]()
        
        // Set 28px of fixed space multiple button items
        let inBetweenSpacing = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        inBetweenSpacing.width = 2
        
        for (index, view) in views.enumerated() {
            
            if index % 2 == 1 {
                // Add in between spacing
                viewItems.append(inBetweenSpacing)
            }
            
            let barButton = UIBarButtonItem(customView: view)
            viewItems.append(barButton)
            
        }
        
        // Set left or right edge button spacing
        let buttonEdgeSpacing = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        buttonEdgeSpacing.width = 0
        
        // Add to left or right of navigation bar
        switch position {
        case .left:
            self.leftBarButtonItem = nil
            self.leftBarButtonItems = [buttonEdgeSpacing]
            self.leftBarButtonItems?.append(contentsOf: viewItems)
        case .right:
            self.rightBarButtonItem = nil
            self.rightBarButtonItems = [buttonEdgeSpacing]
            self.rightBarButtonItems?.append(contentsOf: viewItems)
        }
    }
}
