//
//  URL+QueryParamaters.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import Foundation

extension URL {
     
    func appendingQueryItem(_ name: String, value: Any?) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else {
            return self
        }
         
        urlComponents.queryItems = urlComponents.queryItems?
            .filter { $0.name.caseInsensitiveCompare(name) != .orderedSame } ?? []
         
        // Skip if nil value
        if let value = value {
            urlComponents.queryItems?.append(URLQueryItem(name: name, value: "\(value)"))
        }
         
        return urlComponents.url ?? self
    }
     
    func appendingQueryItems(_ contentsOf: [String: Any?]) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString), !contentsOf.isEmpty else {
            return self
        }
         
        let keys = contentsOf.keys.map { $0.lowercased() }
         
        urlComponents.queryItems = urlComponents.queryItems?
            .filter { !keys.contains($0.name.lowercased()) } ?? []
         
        urlComponents.queryItems?.append(contentsOf: contentsOf.compactMap {
            guard let value = $0.value else { return nil } // Skip if nil
            return URLQueryItem(name: $0.key, value: "\(value)")
        })
         
        return urlComponents.url ?? self
    }
     
    func removeQueryItem(_ name: String) -> URL {
        appendingQueryItem(name, value: nil)
    }
}
 
extension URL {
     
    func queryItem(_ name: String) -> String? {
        URLComponents(string: absoluteString)?
            .queryItems?
            .first { $0.name.caseInsensitiveCompare(name) == .orderedSame }?
            .value
    }
}
