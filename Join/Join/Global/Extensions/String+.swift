//
//  String+.swift
//  Join
//
//  Created by 이윤진 on 2022/07/05.
//

import UIKit

extension String {
    func validateEmail() -> Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let predicate = NSPredicate(format: "SELF MATCHES % @", emailRegEx)
        return predicate.evaluate(with: self)
    }

    func validateNickname() -> Bool {
        let nicknameRegEx = "[가-힣0-9]{2,6}"
        let predicate = NSPredicate(format: "SELF MATCHES % @", nicknameRegEx)
        return predicate.evaluate(with: self)
    }
}
