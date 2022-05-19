//
//  UIFont+.swift
//  Join
//
//  Created by 이윤진 on 2022/05/19.
//

import UIKit

extension UIFont {

    enum Family: String {
        case Black, Bold, Light, Medium, Regular, Thin
    }

    static func minsans(size: CGFloat = 10, family: Family = .Regular) -> UIFont! {
        return UIFont(name: "MinSans-\(family)", size: size)
    }
}
