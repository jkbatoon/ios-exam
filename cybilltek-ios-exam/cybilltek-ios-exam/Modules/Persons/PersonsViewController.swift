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
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
        print("pulled")
        viewModel.refresh()
    }
    
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
        
        output.data
            .skip(1)
            .drive { [weak self] data in
                guard let self = self else { return }
                if refreshControl.isRefreshing {
                    refreshControl.endRefreshing()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setObservers() {
        mainView.tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        mainView.tableView.addSubview(refreshControl)
        
        Observable.zip(
            mainView.tableView.rx.itemSelected,
            mainView.tableView.rx.modelSelected(PersonDetails.self)).bind { 
                [weak self] indexPath, model in
                guard let self = self else { return }
                // push person details view
                navigateToPersonDetailsScreen(data: model)
            }.disposed(by: disposeBag)
    }
    
    private func navigateToPersonDetailsScreen(data: PersonDetails) {
        let vcPersonDetails = PersonDetailsViewController(viewModel: .init(data: data), mainView: .init())
        let visibleVc = NavigationController.getVisibleViewController()
        if let nav = visibleVc.navigationController {
            nav.pushViewController(vcPersonDetails, animated: true)
        }
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

