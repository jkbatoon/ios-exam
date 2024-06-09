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
//        table.alwaysBounceVertical = false
        table.separatorStyle = .none
        table.allowsSelection = false
//        table.transform = CGAffineTransform(scaleX: 1, y: -1)
        table.backgroundColor = .clear
        table.rowHeight = UITableView.automaticDimension
        
        table.register(UINib(nibName: PersonsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PersonsTableViewCell.identifier)
        
        return table
    }()
    
    override func registerTableViewCells() {
        
    }
    
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
