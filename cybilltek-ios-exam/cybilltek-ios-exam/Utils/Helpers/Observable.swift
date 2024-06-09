//
//  Observable.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import Foundation
import RxCocoa
import RxSwift

extension ObservableType where Element == Bool {
    public func not() -> Observable<Bool> {
        map(!)
    }
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        map { _ in }
    }

    func unwrap<Result>() -> SharedSequence<SharingStrategy, Result> where Element == Result? {
        compactMap { $0 }
    }

    func mapTo<Result>(_ value: Result) -> SharedSequence<SharingStrategy, Result> {
        return map { _ in value }
    }
}

extension SharedSequenceConvertibleType where Element == Bool {
    func not() -> SharedSequence<SharingStrategy, Bool> {
        map(!)
    }
}

extension ObservableType {
    func catchErrorJustComplete() -> Observable<Element> {
        `catch` { _ in
            Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        asDriver { _ in
            Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        map { _ in }
    }

    func mapTo<Result>(_ value: Result) -> Observable<Result> {
        return map { _ in value }
    }

    func unwrap<Result>() -> Observable<Result> where Element == Result? {
        compactMap { $0 }
    }
}

extension ObservableType where Self.Element: RxSwift.EventConvertible {
    func elements() -> Observable<Element.Element> {
        compactMap { $0.event.element }
    }

    func errors() -> Observable<Swift.Error> {
        compactMap { $0.event.error }
    }
}
