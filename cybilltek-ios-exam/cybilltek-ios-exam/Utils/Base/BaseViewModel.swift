//
//  BaseViewModel.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import Foundation
import RxSwift

protocol BaseViewModelDefining {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

open class BaseViewModel {
    let disposeBag = DisposeBag()
}
