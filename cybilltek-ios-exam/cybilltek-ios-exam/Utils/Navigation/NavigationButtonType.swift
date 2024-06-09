//
//  NavigationButtonType.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/9/24.
//

import Foundation
import RxCocoa
import UIKit

enum NavigationButtonType {
    
    case back
    case close
    case backCustom(action: PublishRelay<Void>)
    case buttonWithCustom(title: String, color: UIColor, action: PublishRelay<Void>)
    case actionWithIcon(image: UIImage?, action: PublishRelay<Void>)
    
    var menuIcon: UIImage? {

        switch self {
        case .back, .backCustom:
            return Asset.icBackArrow.image
        default:
            return nil
        }
    }
    
    var title: String {
        return ""
    }
}

extension NavigationButtonType: Equatable {
    
    static func == (lhs: NavigationButtonType, rhs: NavigationButtonType) -> Bool {
        
        switch (lhs, rhs) {
        case (.back, .back):
            return true
        case (.close, .close):
            return true
        default:
            return false
        }
    }
}
