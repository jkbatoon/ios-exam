//
//  PersonsViewController.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PersonsViewController: BaseViewController<PersonsView, PersonsViewModel> {
    
    override func setBindings() {
        let initialTrigger = getInitialTrigger()
        
        let output = viewModel
            .transform(input: .init(initialTrigger: initialTrigger))
        
        output.initialTriggered
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.setObservers()
            })
            .disposed(by: disposeBag)
        
        // output.data, .bind to tableview
        output.data
            .drive(mainView.tableView.rx.items(dataSource: viewModel.dataSource()))
            .disposed(by: disposeBag)
        
//        output.data
//            .skip(1)
//            .drive { [weak self] data in
//                guard let self = self else { return }
//                self.handleNoteDisplay(data: data)
//            }
//            .disposed(by: disposeBag)
    }
    
    private func setObservers() {
        mainView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension PersonsViewController: UITableViewDelegate {
    // pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rowCount = tableView.numberOfRows(inSection: 0)
        if !viewModel.isReachedLastPage {
            if rowCount > 2, indexPath.row == (rowCount - 2) {
                viewModel.page += 1
                viewModel.getData()
            }
        }
    }
}

