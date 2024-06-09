//
//  ErrorType.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import Foundation

enum ErrorType {
    case unreachable
    case noInternetConnection
    case unknown
    case expiredToken
    
    var message: String {
        switch self {
        case .unreachable:
            return "Url is unreachable"
        case .noInternetConnection:
            return "No Internet Connection"
        case .unknown:
            return "Unknown Error Occurred"
        case .expiredToken:
            return "Token has expired"
        }
    }
}

extension ErrorType: Equatable {

    static func == (lhs: ErrorType, rhs: ErrorType) -> Bool {
    
        switch (lhs, rhs) {
        case (.unreachable, .unreachable):
            return true
        case (.noInternetConnection, .noInternetConnection):
            return true
        case (.unknown, .unknown):
            return true
        case (.expiredToken, .expiredToken):
            return true
        default:
            return false
        }
    }
}
