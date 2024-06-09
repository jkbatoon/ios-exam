//
//  TableViewBaseCell.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import UIKit
import RxSwift

class TableViewBaseCell: UITableViewCell {
    static let baseCellIdentifier = "TableViewBaseCell"
    var disposeBag = DisposeBag()
        
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: "")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
