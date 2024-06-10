//
//  NavigationItems.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/9/24.
//

enum NavigationItems: Navigation {
    case personsList
    case personDetailView(PersonDetails)
}

extension NavigationItems: Equatable {
    static func == (lhs: NavigationItems, rhs: NavigationItems) -> Bool {
        switch (lhs, rhs) {
        case (.personsList, .personsList):
            return true
        case (.personDetailView, .personDetailView):
            return true
        default:
            return false
        }
    }
}
