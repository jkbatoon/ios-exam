//
//  PersonDetailsView.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class PersonDetailsView: BaseView {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView().usingAutoLayout()
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = true
        view.isUserInteractionEnabled = true
        view.contentInset.bottom = 16
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView().usingAutoLayout()
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    private let stackViewPersonalDetails: UIStackView = {
        let view = UIStackView().usingAutoLayout()
        view.axis = .vertical
        view.spacing = 4
        view.distribution = .equalCentering
        view.alignment = .center
        return view
    }()
    
    private let imgView: UIImageView = {
        let view = UIImageView().usingAutoLayout()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.opacity = 0.8
        view.layoutIfNeeded()
        return view
    }()
    
    private let viewFakeDim: UIView = {
        let view = UIView().usingAutoLayout()
        view.backgroundColor = Asset.Colors.text.color
        return view
    }()
    
    override func setView() {
        backgroundColor = Asset.Colors.themeMain.color
        stackView.addArrangedSubview(imgView)
        scrollView.addSubview(stackView)
        scrollView.isScrollEnabled = true
        addSubview(scrollView)
    }
    
    func setValues(data: PersonDetails) {
        // profile picture
        if let picture = data.picture,
           let profilePicture = picture.large,
           let profilePictureUrl = URL(string: profilePicture) {
            imgView.setImage(withURL: profilePictureUrl)
            viewFakeDim.addSubview(imgView)
            stackView.addArrangedSubview(viewFakeDim)
            
            NSLayoutConstraint.activate([
                imgView.heightAnchor(equalTo: 500),
                
                viewFakeDim.topAnchor(equalTo: imgView.topAnchor),
                viewFakeDim.bottomAnchor(equalTo: imgView.bottomAnchor),
                viewFakeDim.leadingAnchor(equalTo: imgView.leadingAnchor),
                viewFakeDim.trailingAnchor(equalTo: imgView.trailingAnchor),
            ])
        }
        
        // personal details
        let lblFullName = createLabel(text: "\(getFullName(data: data.name))",
                                      style: .heading1,
                                      color: Asset.Colors.themeMain.color,
                                      alignment: .center)
        
        // sections
        let stackSections = UIStackView().usingAutoLayout()
        stackSections.axis = .horizontal
        stackSections.spacing = 4
        stackSections.alignment = .center
        stackSections.distribution = .equalSpacing
        
        stackSections.addArrangedSubviews([
            createSectionView(title: "Age", value: "\(getAge(data: data.dob))"),
            createSectionView(title: "Gender", value: data.gender?.capitalized ?? "NA"),
            createSectionView(title: "Country", value: data.nat ?? "NA"),
        ])
        
        
        stackViewPersonalDetails.addArrangedSubview(lblFullName)
        stackViewPersonalDetails.addArrangedSubview(stackSections)
        
        imgView.addSubview(stackViewPersonalDetails)
        
        NSLayoutConstraint.activate([
            stackViewPersonalDetails.leadingAnchor(equalTo: imgView.leadingAnchor),
            stackViewPersonalDetails.trailingAnchor(equalTo: imgView.trailingAnchor),
            stackViewPersonalDetails.bottomAnchor(equalTo: imgView.bottomAnchor, constant: 16),
        ])
        
        // main details
        stackView.addArrangedSubview(createMainSection(title: "Birthdate", value: getBirthDateString(data: data.dob, format: "yyyy-MM-dd")))
        stackView.addArrangedSubview(createMainSection(title: "Email", value: data.email ?? "NA"))
        stackView.addArrangedSubview(createMainSection(title: "Mobile Number", value: data.cell ?? "NA"))
        stackView.addArrangedSubview(createMainSection(title: "Telephone", value: data.phone ?? "NA"))
        stackView.addArrangedSubview(createMainSection(title: "Location", value: getAddress(location: data.location)))
        stackView.addArrangedSubview(createMainSection(title: "Timezone", value: getTimezone(location: data.location)))
        stackView.addArrangedSubview(createMainSection(title: "Coordinates", value: "\(getCoordinates(location: data.location).0), \(getCoordinates(location: data.location).1)" ))
        
        layoutIfNeeded()
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor(equalTo: bottomAnchor),
            scrollView.leadingAnchor(equalTo: leadingAnchor),
            scrollView.trailingAnchor(equalTo: trailingAnchor),
            
            stackView.topAnchor(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func createSectionView(title: String, value: String) -> UIView {
        let paddingValue: CGFloat = 8.0
        let sectionView = UIView().usingAutoLayout()
        let stackView = UIStackView().usingAutoLayout()
        let lblTitle = createLabel(text: title)
        let lblValue = createLabel(text: value, style: .title1)
        
        sectionView.backgroundColor = Asset.Colors.themeMain.color.withAlphaComponent(0.8)
        sectionView.layer.cornerRadius = 6
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        
        stackView.addArrangedSubviews([
            lblValue,
            lblTitle
        ])
        
        sectionView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            sectionView.widthAnchor(greaterThanOrEqualTo: adaptiveWidth(56)),
            
            stackView.topAnchor(equalTo: sectionView.topAnchor, constant: paddingValue),
            stackView.bottomAnchor(equalTo: sectionView.bottomAnchor, constant: paddingValue),
            stackView.leadingAnchor(equalTo: sectionView.leadingAnchor, constant: paddingValue),
            stackView.trailingAnchor(equalTo: sectionView.trailingAnchor, constant: paddingValue),
        ])
        
        return sectionView
    }
    
    private func createMainSection(title: String, value: String) -> UIView {
        let paddingValue: CGFloat = 16.0
        
        let mainView = UIView().usingAutoLayout()
        let sectionView = UIView().usingAutoLayout()
        let stackView = UIStackView().usingAutoLayout()
        let lblTitle = createLabel(text: title)
        let lblValue = createLabel(text: value, 
                                   style: .title1,
                                   color: Asset.Colors.info.color,
                                   lineBreakmode: .byWordWrapping)
        
        sectionView.backgroundColor = Asset.Colors.subtext.color.withAlphaComponent(0.1)
        sectionView.layer.cornerRadius = 6
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        
        stackView.addArrangedSubviews([
            lblTitle,
            lblValue,
        ])
        
        sectionView.addSubview(stackView)
        mainView.addSubview(sectionView)
        
        NSLayoutConstraint.activate([
//            sectionView.widthAnchor(greaterThanOrEqualTo: adaptiveWidth(56)),
            
            stackView.topAnchor(equalTo: sectionView.topAnchor, constant: paddingValue),
            stackView.bottomAnchor(equalTo: sectionView.bottomAnchor, constant: paddingValue),
            stackView.leadingAnchor(equalTo: sectionView.leadingAnchor, constant: paddingValue),
            stackView.trailingAnchor(equalTo: sectionView.trailingAnchor, constant: paddingValue),
            
            sectionView.topAnchor(equalTo: mainView.topAnchor, constant: 8),
            sectionView.bottomAnchor(equalTo: mainView.bottomAnchor, constant: 8),
            sectionView.leadingAnchor(equalTo: mainView.leadingAnchor, constant: 8),
            sectionView.trailingAnchor(equalTo: mainView.trailingAnchor, constant: 8),
        ])
        
        return mainView
    }
    
    private func createLabel(text: String,
                             style: FontStyle = .body,
                             color: UIColor = Asset.Colors.text.color,
                             alignment: NSTextAlignment = .left,
                             lineBreakmode: NSLineBreakMode = .byTruncatingTail) -> UIView {
        let label = ComponentLabel(style: style,
                                   color: color,
                                   alignment: alignment,
                                   lineBreakmode: lineBreakmode)
        label.text = text
        return label
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
    
    private func getAddress(location: Location?) -> String {
        guard let location = location else { return "NA" }
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
    
    private func getCoordinates(location: Location?) -> (String, String) {
        guard let location = location else { return ("NA", "NA") }
        if let coordinates = location.coordinates,
           let latitude = coordinates.latitude,
           let longitude = coordinates.longitude {
            return (longitude, latitude)
        }
        return ("NA", "NA")
    }
    
    private func getTimezone(location: Location?) -> String {
        guard let location = location else { return "NA" }
        var timezone = String()
        
        if let locTimezone = location.timezone,
           let offset = locTimezone.offset,
           let description = locTimezone.description {
            timezone = "\(offset) \(description)"
        }
        
        return timezone
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
    
    private func getBirthDateString(data: Dob?, format: String) -> String {
        var birthDate = String()
        guard let data = data,
              let birthDateString = data.date else { return birthDate }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:mm.SSSZ"
        if let convertedDate = dateFormatter.date(from: birthDateString) {
            dateFormatter.dateFormat = format
            birthDate = dateFormatter.string(from: convertedDate)
        }
        return birthDate
    }
}

