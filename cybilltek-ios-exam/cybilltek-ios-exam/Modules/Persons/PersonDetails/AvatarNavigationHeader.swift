//
//  AvatarNavigationHeader.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/11/24.
//

import Foundation
import UIKit
import RxGesture
import RxSwift
import RxCocoa

class AvatarNavigationHeader: UIView {
    private let stackView: UIStackView = {
        let view = UIStackView().usingAutoLayout()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        view.spacing = 8
        return view
    }()
    
    private let btnBack: ComponentButton = {
        let view = ComponentButton(style: .image(image: Asset.icBackArrow.image)).usingAutoLayout()
        return view
    }()
    
    private let lblName: ComponentLabel = {
        let view = ComponentLabel(style: .heading2, color: Asset.Colors.themeMain.color).usingAutoLayout()
        return view
    }()
    
    private let imgView: UIImageView = {
        let view = UIImageView().usingAutoLayout()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layoutIfNeeded()
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    func configure(data: PersonDetails) {
        if let picture = data.picture,
           let avatarPicture = picture.large,
           let avatarUrl = URL(string: avatarPicture) {
            imgView.setImage(withURL: avatarUrl)
        }
        lblName.text = getFullName(data: data.name)
        
        setView()
        setConstraints()
        setObservers()
    }
    
    private func setView() {
        stackView.addArrangedSubview(btnBack)
        stackView.addArrangedSubview(imgView)
        stackView.addArrangedSubview(lblName)
        addSubview(stackView)
    }
    
    private func setConstraints() {
        let paddingValue: CGFloat = 8
        NSLayoutConstraint.activate([
            imgView.heightAnchor(equalTo: 40),
            imgView.widthAnchor(equalTo: imgView.heightAnchor),
            
            stackView.topAnchor(equalTo: topAnchor, constant: paddingValue),
            stackView.bottomAnchor(equalTo: bottomAnchor, constant: paddingValue),
            stackView.leadingAnchor(equalTo: leadingAnchor, constant: 16),
        ])
    }
    
    private func setObservers() {
        btnBack.rx
            .tap
            .asObservable()
            .subscribe { _ in
                let visibleVc = NavigationController.getVisibleViewController()
                if let nav = visibleVc.navigationController {
                    nav.popTo(.previous)
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.layer.cornerRadius = imgView.frame.height / 2
    }
    
    private func getFullName(data: Name?) -> String {
        if let name = data,
           let firstName = name.first,
           let lastName = name.last {
            let fullName = "\(firstName) \(lastName)"
            return fullName
        }
        return ""
    }
}
