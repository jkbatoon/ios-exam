//
//  Swizzler.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/9/24.
//

import Foundation

public func swizzleMethod(_ anyClass: AnyClass, fromMethod selector1: Selector, toMethod selector2: Selector) {

    guard let method1: Method = class_getInstanceMethod(anyClass, selector1) else {
        return
    }
    guard let method2: Method = class_getInstanceMethod(anyClass, selector2) else {
        return
    }

    if class_addMethod(anyClass, selector1,
                       method_getImplementation(method2),
                       method_getTypeEncoding(method2)) {

        class_replaceMethod(anyClass,
                            selector2,
                            method_getImplementation(method1),
                            method_getTypeEncoding(method1))
    } else {
        method_exchangeImplementations(method1, method2)
    }
}
