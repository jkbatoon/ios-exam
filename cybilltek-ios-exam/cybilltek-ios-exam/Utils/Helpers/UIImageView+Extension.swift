//
//  UIImageView+Extension.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/9/24.
//

import Kingfisher

extension UIImageView {
    
    func setImage(withURL url: URL?, transition: ImageTransition = .fade(0.2), clearCache: Bool = false) {
        guard let url = url else { return }
        kf.indicatorType = .activity
        kf.setImage(with: url,
                    options: [.transition(transition)])
        clearImageCache(isEnabled: clearCache)
    }
    
    private func clearImageCache(isEnabled: Bool) {
        let cache = ImageCache.default
        if isEnabled {
            cache.clearMemoryCache()
            cache.clearDiskCache { print("**** DONE clearMemoryCache") }
            cache.cleanExpiredCache()
            cache.cleanExpiredCache { print("**** DONE cleanExpiredCache") }
        }
    }

}
