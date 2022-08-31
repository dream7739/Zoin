//
//  UIDevice+.swift
//  Join
//
//  Created by 홍정민 on 2022/08/24.
//

import UIKit

extension UIDevice {
    ////6, 6s, 7, 8  : 365 * 667
    public var isiPhone8: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height == 667 || UIScreen.main.bounds.size.width == 375) {
            return true
        }
        return false
    }
    
    //6+, 6s+, 7+, 8+ : 414 * 736
    public var isiPhone8Plus: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height == 736 || UIScreen.main.bounds.size.width == 414) {
            return true
        }
        return false
    }

    public var isiPhone12mini: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height == 812 && UIScreen.main.bounds.size.width == 375) {
            return true
        }
        return false
    }

    public var isiPone12Pro: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad && (UIScreen.main.bounds.size.height == 844 && UIScreen.main.bounds.size.width == 390) {
            return true
        }
        return false
    }
}
