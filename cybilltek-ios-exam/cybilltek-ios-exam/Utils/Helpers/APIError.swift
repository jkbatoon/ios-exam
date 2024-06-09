//
//  APIError.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import Alamofire

public enum APIError: Error {
    
    case alamofireFailure(error: AFError)
    case apiFailure(message: String)
    case noInternetConnection
    case unknown

    public var message: String {
        switch self {
        case .alamofireFailure(let error):
            return error.localizedDescription
        case .apiFailure(let message):
            return message
        case .noInternetConnection:
            return "No Internet Connection"
        case .unknown:
            return "Unknown Error"
        }
    }
}

extension APIError: Equatable {

    public static func == (lhs: APIError, rhs: APIError) -> Bool {
    
        switch (lhs, rhs) {
        case (.alamofireFailure, .alamofireFailure):
            return true
        case (.apiFailure, .apiFailure):
            return true
        case (.noInternetConnection, .noInternetConnection):
            return true
        case (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}
