//
//  UIDevice+Notch.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/9/24.
//

import Foundation
import UIKit

extension UIDevice {
    static func hasNotch() -> Bool {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                return sceneDelegate.window?.safeAreaInsets.top ?? 0 > 20
            }
        } else {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }

        return false
    }
}
