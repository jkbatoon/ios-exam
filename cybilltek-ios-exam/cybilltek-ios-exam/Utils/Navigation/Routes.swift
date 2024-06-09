//
//  Route.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/9/24.
//

import UIKit

public class Router {
    public static let `default`: IsRouter = DefaultRouter()
}

public protocol Navigation { }
public protocol PopToRouteType { }

public protocol AppNavigation {
    func viewcontrollerForNavigation(navigation: Navigation) -> UIViewController
    func navigate(_ navigation: Navigation, from: UIViewController, to: UIViewController)
    func renavigate(_ navigation: Navigation, from: UIViewController, to: UIViewController)
    func navigateToNewRoot(_ navigation: Navigation)
    func pop(_ type: PopToRouteType, from: UIViewController)
}

public protocol IsRouter {
    func setupAppNavigation(appNavigation: AppNavigation)
    func navigate(_ navigation: Navigation, from: UIViewController)
    func renavigate(_ navigation: Navigation, from: UIViewController)
    func navigateToNewRoot(_ navigation: Navigation)
    func pop(_ type: PopToRouteType, from: UIViewController)
    func didNavigate(block: @escaping (Navigation) -> Void)
    var appNavigation: AppNavigation? { get }
    func showModal(_ navigation: Navigation, from: UIViewController, animated: Bool)
}

public extension UIViewController {
    func navigate(_ navigation: Navigation) {
        Router.default.navigate(navigation, from: self)
    }
    
    func renavigate(_ navigation: Navigation) {
        Router.default.renavigate(navigation, from: self)
    }
    
    func navigateToNewRoot(_ navigation: Navigation) {
        Router.default.navigateToNewRoot(navigation)
    }
    
    func pop(_ type: PopToRouteType) {
        Router.default.pop(type, from: self)
    }

    func showModal(_ navigation: Navigation, animated: Bool) {
        Router.default.showModal(navigation, from: self, animated: animated)
    }
}

public class DefaultRouter: IsRouter {
    
    public var appNavigation: AppNavigation?
    var didNavigateBlocks = [((Navigation) -> Void)]()
    
    public func setupAppNavigation(appNavigation: AppNavigation) {
        self.appNavigation = appNavigation
    }
    
    public func navigate(_ navigation: Navigation, from: UIViewController) {
        if let toVC = appNavigation?.viewcontrollerForNavigation(navigation: navigation) {
            appNavigation?.navigate(navigation, from: from, to: toVC)
            for bnav in didNavigateBlocks {
                bnav(navigation)
            }
        }
    }
    
    public func renavigate(_ navigation: Navigation, from: UIViewController) {
        if let toVC = appNavigation?.viewcontrollerForNavigation(navigation: navigation) {
            appNavigation?.renavigate(navigation, from: from, to: toVC)
            for bnav in didNavigateBlocks {
                bnav(navigation)
            }
        }
    }
    
    public func navigateToNewRoot(_ navigation: Navigation) {
        appNavigation?.navigateToNewRoot(navigation)
        for bnav in didNavigateBlocks {
            bnav(navigation)
        }
    }
    
    public func pop(_ type: PopToRouteType, from: UIViewController) {
        appNavigation?.pop(type, from: from)
    }
    
    public func didNavigate(block: @escaping (Navigation) -> Void) {
        didNavigateBlocks.append(block)
    }

    public func showModal(_ navigation: Navigation, from: UIViewController, animated: Bool = true) {
        if let toVC = appNavigation?.viewcontrollerForNavigation(navigation: navigation) {
            from.present(toVC, animated: animated, completion: nil)
        }
    }
}

// Injection helper
public protocol Initializable { init() }
open class RuntimeInjectable: NSObject, Initializable {
    override public required init() {}
}
