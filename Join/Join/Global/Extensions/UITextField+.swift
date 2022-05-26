//
//  UITextField+.swift
//  Join
//
//  Created by 이윤진 on 2022/04/27.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }

    func setPlaceHolderColor(_ placeholderColor: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor : placeholderColor,
                .font: font
            ].compactMapValues { $0 }
        )
    }
}
