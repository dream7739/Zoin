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
    
    //2022-07-21T14:17:21.234702316 -> 07.21
    //당일인 경우에는 "오늘"로 변경함
    func dateTypeChange(dateStr: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //서버 전송 타입
        
        let convertDate = dateFormatter.date(from: dateStr) //String -> date
        
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.locale = Locale(identifier: "ko-KR")
        
        var convertDateStr = ""
        
        //오늘 날짜인지 확인
        let current = Calendar.current
        if current.isDateInToday(convertDate!){
            displayDateFormatter.dateFormat = "오늘 a hh:mm"
            convertDateStr = displayDateFormatter.string(from: convertDate!)
        }else {
            displayDateFormatter.dateFormat = "M월 d일 a hh:mm"
            convertDateStr = displayDateFormatter.string(from: convertDate!)
        }
        
        return convertDateStr
    }
}
