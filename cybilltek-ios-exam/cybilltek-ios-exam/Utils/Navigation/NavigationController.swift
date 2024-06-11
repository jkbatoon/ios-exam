//
//  NavigationController.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/9/24.
//

import RxCocoa
import RxSwift
import UIKit

class NavigationController: UINavigationController {
    
    let disposeBag = DisposeBag()
    static let diseposeBag = DisposeBag()
    
    private enum NavigationBar {
        static let defaultColor = Asset.Colors.themeMain.color
        static let height: CGFloat = 107
    }
    
    var targetVc: UIViewController?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        view.backgroundColor = Asset.Colors.disable.color
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Setup Bottom Navigation
//        BottomNavigationManager.shared.setup(to: self)
        setupNavigationBar()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // Push view controller
        CATransaction.begin()
        
        super.pushViewController(viewController, animated: animated)
        self.setupNavigationBarColor(viewController: viewController)
        
        self.setupNavigationBarButtons(viewController: viewController)
        self.setupNavigationBarTitle(viewController: viewController)
        self.setUpNavigationBarVisibility(viewController: viewController)
        CATransaction.commit()
    }
    
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        setupNavigationBarButtons(viewController: viewControllerToPresent)
        setupNavigationBarTitle(viewController: viewControllerToPresent)
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        
        let poppedVC = super.popViewController(animated: animated)
        if let vct = self.viewControllers.last {
            self.setupNavigationBarButtons(viewController: vct)
            self.setupNavigationBarTitle(viewController: vct)
            
            self.setUpNavigationBarVisibility(viewController: vct)
        }
        return poppedVC
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static func enableEdgeSwipe(enable: Bool,
                                fromViewController: UIViewController = NavigationController.getVisibleViewController()) {
        fromViewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = enable
    }
    
    // MARK: - Public methods
    static func getVisibleViewController() -> UIViewController {
        
        var viewController = UIViewController()
        var presented = UIViewController()
        
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let rootVc = sceneDelegate.window?.rootViewController {
                viewController = rootVc
                presented = rootVc
            }
        } else {
            if let rootVC = UIApplication.shared.delegate?.window??.rootViewController {
                viewController = rootVC
                presented = rootVC
            }
        }
        
        while let topVC = presented.presentedViewController {
            presented = topVC
            viewController = topVC
        }
        
        if let presentVC = viewController as? NavigationController {
            if let lastViewController = presentVC.viewControllers.last {
                viewController = lastViewController
            }
        }
        
        return viewController
    }
    
    static func previousController() -> UIViewController {
        
        var viewController = UIViewController()
        var presented = UIViewController()
        
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let rootVc = sceneDelegate.window?.rootViewController {
                viewController = rootVc
                presented = rootVc
            }
        } else {
            if let rootVC = UIApplication.shared.delegate?.window??.rootViewController {
                viewController = rootVC
                presented = rootVC
            }
        }
        
        while let topVC = presented.presentedViewController {
//            if topVC.isKind(of: loading controller ) {
//                break
//            } else {
//                presented = topVC
//                viewController = topVC
//            }
            presented = topVC
            viewController = topVC
        }
        
        if let presentVC = viewController as? NavigationController {
            let count = presentVC.viewControllers.count
            let lastViewController = presentVC.viewControllers[count - 2]
            viewController = lastViewController
        }
        
        return viewController
    }
    
    
    static func getController(_ name: UIViewController.Type) -> UIViewController {
        if let nav = NavigationController.getVisibleViewController().navigationController as? NavigationController {
            for vc in nav.viewControllers {
                if vc.isKind(of: name.self) {
                    return vc
                }
            }
        }
        return UIViewController()
    }
    
    static func getHeight() -> CGFloat {
        var top: CGFloat = 0.0
        if let nav = NavigationController.getVisibleViewController().navigationController {
            if UIDevice.hasNotch() {
                top += nav.navigationBar.frame.maxY.magnitude
                top += nav.navigationBar.frame.height / 3
            } else {
                top += nav.navigationBar.frame.maxY.magnitude
                top += nav.navigationBar.frame.height
            }
        }
        return top
    }
    
}

extension NavigationController {
    
    private func setupNavigationBar() {
        navigationBar.isTranslucent = true
        navigationBar.barStyle = .default
        navigationBar.shadowImage = UIImage()
    }
    
    private func setupNavigationBarColor(viewController: UIViewController) {
        navigationBar.barTintColor = NavigationBar.defaultColor
    }
    
    func setUpNavigationBarVisibility(viewController: UIViewController) {
        switch viewController {
        case is PersonDetailsViewController:
            setNavigationBarHidden(true, animated: true)
        default:
            setNavigationBarHidden(true, animated: false)
        }
        
        setNavigationBarShadow(viewController: viewController)
    }
    
    private func setNavigationBarShadow(viewController: UIViewController) {
        if !navigationBar.isHidden {
            var color: UIColor?
            
            if let color = color {
                navigationBar.layer.shadowColor = color.cgColor
                navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                navigationBar.layer.shadowOpacity = 1.0
                navigationBar.layer.masksToBounds = false
            }
        }
    }
    
    
    func setupNavigationBarTitle(viewController: UIViewController) {
        let (controllerIconTitle, titleColor) = viewControllerIconTitle(viewController)
        let title = viewController.title ?? controllerIconTitle
        
        // Need to hide the back button on each view controller as it shows up sometimes during the push animation
        viewController.navigationItem.setHidesBackButton(true, animated: false)
        
        NavigationController.setTitleView(title: title, color: titleColor, viewController: viewController)
    }
        
    private func viewControllerIconTitle(_ viewController: UIViewController) -> (String, UIColor?) {
        
        var title = ""
        var titleColor: UIColor? = nil
        
        switch viewController {
//        case is PersonDetailsViewController:
//            title = "Person Details"
//            titleColor = Asset.Colors.themeMain.color
//            if let vc = viewController as? PersonDetailsViewController {
//                let vcPersonDetails = vc.viewModel.personDetails
//                if let name = vcPersonDetails.name,
//                   let first = name.first,
//                   let last = name.last {
//                    let fullName = "\(first) \(last)"
//                    title = fullName
//                }
//            }
//            self.setNavigationBarColor(color: Asset.Colors.text.color)
        default:
            self.setNavigationBarColor(color: .clear)
        }
        return (title, titleColor)
    }
    
    static func setTitleView(title: String, color: UIColor? = nil, viewController: UIViewController = NavigationController.getVisibleViewController()) {
        if let leftItems = viewController.navigationItem.leftBarButtonItems {
            var hasTitle = false
            for leftItem in leftItems {
                if let customView = leftItem.customView, customView.isKind(of: NavigationTitleView.self) {
                    hasTitle = true
                    break
                }
            }
            
            if !hasTitle {
                let title = UIBarButtonItem(customView: NavigationTitleView(title: title, titleColor: color))
                viewController.navigationItem.leftBarButtonItems?.append(title)
            }
        }
    }
    
    func updateNavigationTitle(title: String, viewController: UIViewController = NavigationController.getVisibleViewController()) {
        updateNavTitle(title: title, viewController: viewController)
    }
    
    func updateNavigationTitle(title: String, color: UIColor, viewController: UIViewController = NavigationController.getVisibleViewController()) {
        updateNavTitle(title: title, color: color, viewController: viewController)
    }
    
    private func updateNavTitle(title: String, color: UIColor? = nil, viewController: UIViewController = NavigationController.getVisibleViewController()) {
        if let leftItems = viewController.navigationItem.leftBarButtonItems {
            var hasTitle = false
            for leftItem in leftItems {
                if let customView = leftItem.customView as? NavigationTitleView {
                    hasTitle = true
                    customView.title.text = title.capitalized
                    if let color = color {
                        customView.title.textColor = color
                    }
                    break
                }
            }

            if !hasTitle {
                var titleBar: UIBarButtonItem
                if let color = color {
                    titleBar = UIBarButtonItem(customView: NavigationTitleView(title: title, icon: nil, color: color))
                } else {
                    titleBar = UIBarButtonItem(customView: NavigationTitleView(title: title))
                }
                viewController.navigationItem.leftBarButtonItems?.append(titleBar)
            }
        }
    }
    
    func setNavigationBarColor(color: UIColor) {
        navigationBar.backgroundColor = color
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            navigationBar.isTranslucent = true
            appearance.shadowColor = .clear
            appearance.backgroundColor = color
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    func setupNavigationBarButtons(viewController: UIViewController) {
        // add desired controller for back button
        switch viewController {
//        case is PersonDetailsViewController:
//            viewController.navigationItem.addButtons(types: [.back], position: .left, disposeBag: disposeBag)
        default:
            break
        }
    }
    
    static func displayNav() {
        let vc = NavigationController.getVisibleViewController()
        if let nav = vc.navigationController as? NavigationController {
            nav.setupNavigationBarTitle(viewController: vc)
            nav.setUpNavigationBarVisibility(viewController: vc)
        }
    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension NavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController, animated: Bool) {
        NavigationController.enableEdgeSwipe(enable: false, fromViewController: viewController)
        navigationController.interactivePopGestureRecognizer?.delegate = self
    }
}
