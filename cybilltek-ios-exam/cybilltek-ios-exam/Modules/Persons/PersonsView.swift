//
//  PersonsView.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import Foundation
import RxCocoa
import RxSwift

class PersonsView: BaseView {
    let tableView: UITableView = {
        let table = UITableView().usingAutoLayout()
        table.separatorStyle = .none
        table.allowsSelection = true
        table.backgroundColor = .clear
        table.selectionFollowsFocus = true
        table.rowHeight = UITableView.automaticDimension

        table.register(PersonsTableViewCell.self, forCellReuseIdentifier: PersonsTableViewCell.identifier)
        
        table.layoutIfNeeded()
        return table
    }()
    
    override func setView() {
        backgroundColor = Asset.Colors.themeMain.color
        addSubview(tableView)
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor(equalTo: bottomAnchor),
            tableView.leadingAnchor(equalTo: leadingAnchor),
            tableView.trailingAnchor(equalTo: trailingAnchor),
        ])
    }
}

extension PersonsView: UITableViewDelegate {
    
}
