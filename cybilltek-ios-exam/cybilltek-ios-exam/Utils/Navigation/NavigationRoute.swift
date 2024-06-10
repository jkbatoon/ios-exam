//
//  NavigationRoute.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/9/24.
//

import UIKit

enum RouteType: PopToRouteType {
    case root
    case previous
    case target(_ target: UIViewController)
}

extension RouteType: Equatable {
    static func == (lhs: RouteType, rhs: RouteType) -> Bool {
        switch (lhs, rhs) {
        case (.root, .root):
            return true
        case (.previous, .previous):
            return true
        default:
            return false
        }
    }
}

struct NavigationRoute: AppNavigation {
    func viewcontrollerForNavigation(navigation: Navigation) -> UIViewController {
        if let navigation = navigation as? NavigationItems {
            return getController(for: navigation)
        }
        return UIViewController()
    }
    
    private func getController(for navigation: NavigationItems) -> UIViewController {
        switch navigation {
        case .personsList:
            let vc = PersonsViewController(viewModel: .init(), mainView: .init())
            return vc
        case .personDetailView(let data):
            let vc = PersonDetailsViewController(viewModel: .init(data: data), mainView: .init())
            return vc
        default: break
        }
        return UIViewController()
    }

    func navigate(_ navigation: Navigation, from: UIViewController, to: UIViewController) {
        // Check if in the same VC
        if type(of: from) != type(of: to) {

            // Check if VC is already in stack
            if let viewControllers = from.navigationController?.viewControllers {
                let reuseVCS = viewControllers.filter{ return $0.isKind(of: type(of: to)) }
                if let reuseVC = reuseVCS.first {
                    // VC is in the stack already, let's reuse it
                    from.navigationController?.popToViewController(reuseVC, animated: true)
                } else {
                    from.navigationController?.pushViewController(to, animated: true)
                }
            } else if from.isKind(of: UINavigationController.self), let navigationVC = from as? UINavigationController {
                navigationVC.pushViewController(to, animated: true)
            }
        }
    }
    
    func renavigate(_ navigation: Navigation, from: UIViewController, to: UIViewController) {
        // Check if in the same VC
        from.navigationController?.pushViewController(to, animated: true)
    }

    
    func navigateToNewRoot(_ navigation: Navigation) {
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else {
            return
        }
        
        let newRootVC = viewcontrollerForNavigation(navigation: navigation)
        let nav = NavigationController(rootViewController: newRootVC)
        
        window.rootViewController = nav
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
    func pop(_ type: PopToRouteType, from: UIViewController) {
        
        if from.presentingViewController != nil {
            from.dismiss(animated: true, completion: nil)
            return
        }
        
        if let popType = type as? RouteType {
            switch popType {
            case .previous:
                if let navigation = from as? UINavigationController { // handle navigation from custom modals
                    navigation.popViewController(animated: true)
                } else {
                    from.navigationController?.popViewController(animated: true)
                }
            case .root:
                if let nav = from.navigationController as? NavigationController,
                    let rootVc = nav.viewControllers.first {
                }
                from.navigationController?.popToRootViewController(animated: true)
            case .target(let target):
                if let vc = from.navigationController as? NavigationController {
                    vc.targetVc = nil
                    vc.popToViewController(target, animated: true)
                }
            }
        }
    }
}

extension UIViewController {

    func navigate(_ navigation: NavigationItems) {
        navigate(navigation as Navigation)
        UIViewController.updateBottomNavigationState(navigation)
    }
    
    func renavigate(_ navigation: NavigationItems) {
        renavigate(navigation as Navigation)
        UIViewController.updateBottomNavigationState(navigation)
    }
    
    func navigateToNewRoot(_ navigation: NavigationItems) {
        navigateToNewRoot(navigation as Navigation)
        UIViewController.updateBottomNavigationState(navigation)
    }
    
    func popTo(_ type: RouteType) {
        pop(type as PopToRouteType)
    }
    
    static func updateBottomNavigationState(_ navigation: NavigationItems? = nil) {
    }

    func showModal(_ navigation: NavigationItems, animated: Bool = true) {
        showModal(navigation as Navigation, animated: animated)
    }
}
