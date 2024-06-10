//
//  PersonDetailsViewModel.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class PersonDetailsViewModel: BaseViewModel, BaseViewModelDefining {
    let data = BehaviorRelay<PersonDetails?>(value: nil)
    let fetchedPersonDetails = PublishSubject<PersonDetails>()
    var personDetails = PersonDetails()
    
    struct Input {
        let initialTrigger: Driver<Void>
    }

    struct Output {
        let initialTriggered: Driver<Void>
        let data: Driver<PersonDetails?>
    }
    
    init(data: PersonDetails) {
        self.personDetails = data
    }
    
    func transform(input: Input) -> Output {
        let initialTrigger = input.initialTrigger
            .do(onNext: { [weak self] in
                guard let self = self else { return }
                self.completeInitialTrigger()
            })
        
        return Output(initialTriggered: initialTrigger, data: data.asDriver())
    }
    
    private func completeInitialTrigger() {
        self.data.accept(personDetails)
    }
}
