//
//  NavigationButtonPositionType.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/9/24.
//

enum NavigationButtonPositionType {
    
    case left
    case right
}

extension NavigationButtonPositionType: Equatable {
    
    static func == (lhs: NavigationButtonPositionType, rhs: NavigationButtonPositionType) -> Bool {
        
        switch (lhs, rhs) {
        case (.left, .left):
            return true
        case (.right, .right):
            return true
        default:
            return false
        }
    }
}
