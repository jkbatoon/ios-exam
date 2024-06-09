//
//  PersonsViewModel.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class PersonsViewModel: BaseViewModel, BaseViewModelDefining {
    private let data = BehaviorRelay<[PersonsDataSource]>(value: [])
    
    var page = 1
    var isReachedLastPage = false
    
    struct Input {
        let initialTrigger: Driver<Void>
    }

    struct Output {
        let initialTriggered: Driver<Void>
        let data: Driver<[PersonsDataSource]>
    }
    
    init(data: Any? = nil) {}
    
    func transform(input: Input) -> Output {
        let initialTrigger = input.initialTrigger
            .do(onNext: { [weak self] in
                guard let self = self else { return }
                self.completeInitialTrigger()
            })
        
        return Output(initialTriggered: initialTrigger,
                      data: data.asDriver())
    }
    
    private func completeInitialTrigger() {
        getData()
    }
    
    func getData() {
        let service = PersonsService()
        service.getPersonsData(page: page)?
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .idle: 
                    print("loading")
                case .success(let data):
                    print(data);
                    self.handleSuccessResponse(data: data)
                case .error(let error):
                    print(error.message)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func handleSuccessResponse(data: [PersonDetails]?) {
        guard let response = data else {
            isReachedLastPage = true
            return
        }
        
        isReachedLastPage = false
        
        if self.page > 1 {
            if var currentData = self.data.value.last {
                currentData.items.append(contentsOf: response)
                self.data.accept([currentData])
            }
        } else {
            self.data.accept([PersonsDataSource(items: response)])
        }
    }
}

extension PersonsViewModel {
    typealias DataSource = RxTableViewSectionedReloadDataSource<PersonsDataSource>
    func dataSource() -> DataSource {
        DataSource(
            configureCell: { _, tableView, indexPath, data in
                // set table view cell
                if let cell = tableView.dequeueReusableCell(withIdentifier: PersonsTableViewCell.identifier) as? PersonsTableViewCell {
                    cell.configure(data: data)
                    cell.backgroundColor = .clear
                    return cell
                }
                
                let prevCell = tableView.dequeueReusableCell(withIdentifier: TableViewBaseCell.baseCellIdentifier)
                return prevCell ?? TableViewBaseCell()
            }
        )
    }
}
