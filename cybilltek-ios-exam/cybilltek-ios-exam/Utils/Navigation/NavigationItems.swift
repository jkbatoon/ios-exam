//
//  NavigationItems.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/9/24.
//

enum NavigationItems: Navigation {
    case personsList
}

extension NavigationItems: Equatable {
    static func == (lhs: NavigationItems, rhs: NavigationItems) -> Bool {
        switch (lhs, rhs) {
        case (.personsList, .personsList):
            return true
        default:
            return false
        }
    }
}
