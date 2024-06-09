//
//  BaseView.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import Foundation
import UIKit

open class BaseView: UIView {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setView()
        setConstraints()
        registerTableViewCells()
        setObservers()
    }
    
    open override func awakeFromNib() {
        setView()
        setConstraints()
        registerTableViewCells()
        setObservers()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func setView() {}
    public func setConstraints() {}
    public func registerTableViewCells() {}
    public func setObservers() {}
}
