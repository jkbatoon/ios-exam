//
//  JSONDictionary.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import Foundation

public typealias JSONDictionary = [String: Any]

func convertJSONtoData(dict: JSONDictionary) -> Data? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        return jsonData
    } catch {
        return nil
    }
}

func convertDataToJSON(data: Data) -> JSONDictionary? {
    
    do {
        let decoded = try JSONSerialization.jsonObject(with: data, options: [])
    
        if let dictFromJSON = decoded as? JSONDictionary {
            return dictFromJSON
        } else {
            return nil
        }
        
    } catch {
        return nil
    }
}
