//
//  BaseViewController.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol ViewControllerDefining {
    associatedtype MainView: UIView
    associatedtype ViewModel

    var mainView: MainView { get }
    var viewModel: ViewModel { get }
}

open class BaseViewController<MainView: UIView, ViewModel>: UIViewController, ViewControllerDefining {
    var disposeBag = DisposeBag()
    internal var customNavigationBar: UINavigationBar?
    var screenName: String = ""

    private let navHeight: CGFloat = 50
    public let viewModel: ViewModel
    public let mainView: MainView

    // MARK: - Lifecycle
    init(viewModel: ViewModel, mainView: MainView) {
        self.viewModel = viewModel
        self.mainView = mainView
        super.init(nibName: nil, bundle: nil)
        setBindings()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        view = mainView
    }
    
    func getInitialTrigger() -> Driver<Void> {
        var initialTrigger: Driver<Void>
        // Please do not change the initial trigger to view will appear.
        // We do not want to re-fetch or refresh the data when moving from the pushed screen.
        let viewDidLoad = rx.sentMessage(#selector(UIViewController.viewDidLoad))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        initialTrigger = viewDidLoad

        return initialTrigger
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    /// Override this method to configure all of your Rx bindings for both inputs and outputs.
    public func setBindings() {}
    
    func updateNavTitle(title: String, color: UIColor = Asset.Colors.themeMain.color) {
        if let nav = self.navigationController as? NavigationController {
            nav.updateNavigationTitle(title: title, color: color)
        }
    }
    
    func updateNavBackgroundColor(color: UIColor) {
        if let nav = self.navigationController as? NavigationController {
            nav.setNavigationBarColor(color: color)
        }
    }
    
    func addCustomNavigationBar(color: UIColor = Asset.Colors.themeSecondary.color, title: String? = nil, titleColor: UIColor? = nil, buttons: [NavigationButtonType], showLeftButton: Bool = true) {
        
        let navbar = UINavigationBar(frame: CGRect(x: 0,
                                                   y: navHeight,
                                                   width: UIScreen.main.bounds.size.width,
                                                   height: 51))
        navbar.tintColor = color
        navbar.isTranslucent = true
        navbar.barStyle = .default
        navbar.shadowImage = UIImage()
        navbar.setBackgroundImage(UIImage().imageWithColor(color: color), for: .default)
        navbar.barTintColor = color
        
        let navigationItem = UINavigationItem()
        
        if let title = title {
            // Create a navigation item with a title
            navigationItem.titleView = NavigationTitleView(title: title.capitalized, titleColor: titleColor)
        }
        
        if let leftButton = buttons.first {
            let navItem = UINavigationItem()
            // Create left button
            navItem.addButtons(types: [leftButton], position: .left, disposeBag: self.disposeBag)
            navigationItem.leftBarButtonItems = navItem.leftBarButtonItems
        }
        
        if let rightButton = buttons.last, buttons.count > 1 {
            // Create right button
            let navItem = UINavigationItem()
            navItem.addButtons(types: [rightButton], position: .right, disposeBag: self.disposeBag)
            navigationItem.rightBarButtonItems = navItem.rightBarButtonItems
        }
        
        if !showLeftButton {
            navigationItem.removeButtons(at: .left)
        }
        
        navbar.items = [navigationItem]
        customNavigationBar = navbar
        view.addSubview(navbar)

        // prevents weird re-positioning behavior
        NSLayoutConstraint.activate([
            navbar.topAnchor.constraint(equalTo: view.topAnchor, constant: navHeight),
            navbar.leadingAnchor(equalTo: view.leadingAnchor),
            navbar.trailingAnchor(equalTo: view.trailingAnchor),
            navbar.heightAnchor.constraint(equalToConstant: 51)
        ])
    }
}
