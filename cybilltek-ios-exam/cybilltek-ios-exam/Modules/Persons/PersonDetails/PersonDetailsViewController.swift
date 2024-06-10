//
//  PersonDetailsViewController.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class PersonDetailsViewController: BaseViewController<PersonDetailsView, PersonDetailsViewModel> {
    override func setBindings() {
        let initialTrigger = getInitialTrigger()
        
        let output = viewModel
            .transform(input: .init(initialTrigger: initialTrigger))
        
        output.data
            .drive(onNext: { [weak self] data in
                guard let self = self, 
                      let fetchedData = data
                else { return }
                self.mainView.setValues(data: fetchedData)
            })
            .disposed(by: disposeBag)
        
        output.initialTriggered
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.setObservers()
            })
            .disposed(by: disposeBag)
    }
    
    private func setObservers() {
       
    }
}
