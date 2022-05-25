//
//  MinSansFont.swift
//  Join
//
//  Created by 이윤진 on 2022/05/19.
//

import UIKit

enum MinSansFont: String {
    case black = "MinSans-Black"
    case bold = "MinSans-bold"
    case light = "MinSans-Light"
    case medium = "MinSans-Medium"
    case regular = "MinSans-Regular"
    case thin = "MinSans-Thin"

    func of(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: self.rawValue, size: size) else {
            return .systemFont(ofSize: size)
        }
        return font
    }
}
