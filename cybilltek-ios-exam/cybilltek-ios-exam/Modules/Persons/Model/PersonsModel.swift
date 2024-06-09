//
//  PersonsModel.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import Foundation

// MARK: - PersonsModel
struct PersonsModel: Codable {
    var results: [PersonDetails]?
    var info: Info?
}

// MARK: - Info
struct Info: Codable {
    var seed: String?
    var results, page: Int?
    var version: String?
}

// MARK: - Result
struct PersonDetails: Codable {
    var gender: String?
    var name: Name?
    var location: Location?
    var email: String?
    var login: Login?
    var dob, registered: Dob?
    var phone, cell: String?
//    var id: String?
    var picture: Picture?
    var nat: String?
}

// MARK: - Dob
struct Dob: Codable {
    var date: String?
    var age: Int?
}

// MARK: - Location
struct Location: Codable {
    var street: Street?
    var city, state, country: String?
//    var postcode: Int?
    var coordinates: Coordinates?
    var timezone: Timezone?
}

// MARK: - Coordinates
struct Coordinates: Codable {
    var latitude, longitude: String?
}

// MARK: - Street
struct Street: Codable {
    var number: Int?
    var name: String?
}

// MARK: - Timezone
struct Timezone: Codable {
    var offset, description: String?
}

// MARK: - Login
struct Login: Codable {
    var uuid, username, password, salt: String?
    var md5, sha1, sha256: String?
}

// MARK: - Name
struct Name: Codable {
    var title, first, last: String?
}

// MARK: - Picture
struct Picture: Codable {
    var large, medium, thumbnail: String?
}
