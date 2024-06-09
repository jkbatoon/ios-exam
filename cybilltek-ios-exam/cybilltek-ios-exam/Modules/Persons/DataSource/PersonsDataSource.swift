//
//  PersonsDataSource.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import RxDataSources

struct PersonsDataSource {
    var items: [Item]

    init(items: [Item]) {
        self.items = items
    }
}

extension PersonsDataSource: SectionModelType {
    typealias Item = PersonDetails

    init(original: PersonsDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
