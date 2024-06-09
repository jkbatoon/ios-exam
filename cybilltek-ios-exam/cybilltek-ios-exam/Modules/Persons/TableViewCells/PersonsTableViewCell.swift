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
    
    @IBOutlet weak var stackView: UIStackView!
    
    let imgView: UIImageView = {
        let view = UIImageView().usingAutoLayout()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    
    func configure(data: PersonDetails) {
        setView(using: data)
    }
    
    private func setView(using: PersonDetails) {
        let personInfo = using
        
        // setup stack view
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        // assign values
        // avatar
        if let picture = personInfo.picture,
           let imgUrl = picture.large {
            let avatarUrl = URL(string: imgUrl)
            imgView.setImage(withURL: avatarUrl)
            stackView.addArrangedSubview(imgView)
        }
        
        // full name
        if let name = personInfo.name,
           let firstName = name.first,
           let lastName = name.last {
            let fullName = "\(lastName), \(firstName)"
            let lblFullName = createLabel(text: fullName, style: .title2)
            stackView.addArrangedSubview(lblFullName)
        }
        
        // address
        if let location = personInfo.location {
            let lblAddress = createLabel(text: getAddress(location: location))
            stackView.addArrangedSubview(lblAddress)
        }
        
        // contact info
        if let email = personInfo.email,
           let mobile = personInfo.cell {
            // container for contac infos
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
            stackView.addArrangedSubview(contactInfoContainer)
        }
        
        // birthday and age
        if let dateOfBirth = personInfo.dob,
           let bday = dateOfBirth.date,
           let age = dateOfBirth.age {
            // container for bday and age
            let birthInfoContainer: UIStackView = {
                let view = UIStackView().usingAutoLayout()
                view.axis = .horizontal
                view.alignment = .leading
                view.spacing = 4
                return view
            }()
            
            let lblBday = createLabel(text: bday)
            let lblAge = createLabel(text: "\(age)")
            birthInfoContainer.addArrangedSubview(lblBday)
            birthInfoContainer.addArrangedSubview(lblAge)
            stackView.addArrangedSubview(birthInfoContainer)
        }

        //        Contact person
        //        Contact person's phone number
        
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
    
}
