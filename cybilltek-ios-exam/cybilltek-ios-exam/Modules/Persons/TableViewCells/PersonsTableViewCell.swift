//
//  PersonsTableViewCell.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import Foundation
import UIKit

class PersonsTableViewCell: UITableViewCell {
    static let identifier = "PersonsTableViewCell"
    
    let stackViewInfo: UIStackView = {
        let view = UIStackView().usingAutoLayout()
        view.axis = .vertical
        view.spacing = 4
        view.alignment = .leading
        view.distribution = .fill
        return view
    }()
    
    let imgView: UIImageView = {
        let view = UIImageView().usingAutoLayout()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
//        view.layoutIfNeeded()
        return view
    }()
    
    let viewAvatarFrame: UIView = {
        let view = UIView().usingAutoLayout()
        view.clipsToBounds = true
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return view
    }()
    
    func configure(data: PersonDetails) {
        setView(using: data)
    }
    
    private func setView(using: PersonDetails) {
        let personInfo = using
        
        // reinitialized items for stack view
        stackViewInfo.removeArrangedSubviews()
        
        // assign values
        // avatar
        if let picture = personInfo.picture,
           let imgUrl = picture.large {
            let avatarUrl = URL(string: imgUrl)
            imgView.setImage(withURL: avatarUrl)
            viewAvatarFrame.addSubview(imgView)
        }
        
        // full name
        if let name = personInfo.name,
           let firstName = name.first,
           let lastName = name.last {
            let fullName = "\(firstName) \(lastName)"
            let nameAgeContainer: UIStackView = {
                let view = UIStackView().usingAutoLayout()
                view.axis = .horizontal
                view.alignment = .leading
                view.spacing = 4
                return view
            }()
            
            let lblFullName = createLabel(text: "\(fullName),", style: .heading1)
            let lblAge = createLabel(text: "\(getAge(data: personInfo.dob))", style: .heading1)
            
            nameAgeContainer.addArrangedSubview(lblFullName)
            nameAgeContainer.addArrangedSubview(lblAge)
            
            stackViewInfo.addArrangedSubview(nameAgeContainer)
        }
        
        // address
        if let location = personInfo.location {
            let lblAddress = createLabel(text: getAddress(location: location))
            stackViewInfo.addArrangedSubview(lblAddress)
        }
        
        // contact info
        if let email = personInfo.email,
           let mobile = personInfo.cell {
            // container for contact infos
            let contactInfoContainer: UIStackView = {
                let view = UIStackView().usingAutoLayout()
                view.axis = .horizontal
                view.alignment = .leading
                view.spacing = 4
                return view
            }()
            
            let lblEmail = createLabel(text: email, color: .info)
            let lblMobileNumber = createLabel(text: mobile)
            contactInfoContainer.addArrangedSubview(lblEmail)
            contactInfoContainer.addArrangedSubview(lblMobileNumber)
            stackViewInfo.addArrangedSubview(contactInfoContainer)
        }
        
        contentView.addSubview(viewAvatarFrame)
        contentView.addSubview(stackViewInfo)
        setConstraints()
        contentView.layoutIfNeeded()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imgView.heightAnchor(equalTo: 80),
            imgView.widthAnchor(equalTo: imgView.heightAnchor),
            
            imgView.topAnchor(equalTo: viewAvatarFrame.topAnchor),
            imgView.bottomAnchor(equalTo: viewAvatarFrame.bottomAnchor),
            imgView.leadingAnchor(equalTo: viewAvatarFrame.leadingAnchor),
            imgView.trailingAnchor(equalTo: viewAvatarFrame.trailingAnchor),
            
            viewAvatarFrame.leadingAnchor(equalTo: contentView.leadingAnchor, constant: 16),
            viewAvatarFrame.topAnchor(equalTo: contentView.topAnchor, constant: 8),
            viewAvatarFrame.bottomAnchor(equalTo: contentView.bottomAnchor, constant: 8),
            
            stackViewInfo.centerYAnchor(equalTo: viewAvatarFrame.centerYAnchor),
            stackViewInfo.leadingAnchor(equalTo: viewAvatarFrame.trailingAnchor, constant: 16),
            stackViewInfo.trailingAnchor(equalTo: contentView.trailingAnchor, constant: 16)
        ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewAvatarFrame.layer.cornerRadius = imgView.frame.height / 2
    }
    
    private func createLabel(text: String,
                             style: FontStyle = .body,
                             color: UIColor = Asset.Colors.text.color) -> UIView {
        let label = ComponentLabel(style: style, color: color)
        label.text = text
        return label
    }
    
    private func getAddress(location: Location) -> String {
        var address = String()
        
        if let street = location.street,
           let streetNumber = street.number,
           let streetName = street.name {
            let streetDetails = "\(streetNumber) \(streetName)"
            address.append(streetDetails)
        }
        
        if let city = location.city {
            address.append(" \(city),")
        }
        
        if let state = location.state {
            address.append(" \(state),")
        }
        
        if let country = location.country {
            address.append(" \(country)")
        }
        
        return address
    }
    
    private func getAge(data: Dob?) -> Int {
        guard let data = data else { return 0 }
        let now = Date()
        let birthday = getBirthDate(data: data)
        let calendar = Calendar.current
        let dataComponent = calendar.dateComponents([.year], from: birthday, to: now)
        if let calculatedAge = dataComponent.year {
            return calculatedAge
        }
        return 0
    }
    
    private func getBirthDate(data: Dob?) -> Date {
        var birthDate = Date()
        guard let data = data,
              let birthDateString = data.date else { return birthDate }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:mm.SSSZ"
        if let convertedDate = dateFormatter.date(from: birthDateString) {
            birthDate = convertedDate
        }
        return birthDate
    }
}
