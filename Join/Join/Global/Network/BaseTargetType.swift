//
//  BaseTargetType.swift
//  Join
//
//  Created by 이윤진 on 2022/04/20.
//

import Moya

protocol BaseTargetType: TargetType { }

extension BaseTargetType {
    //    var baseURL: URL {
    //        return URL(string: "")
    //    }
    //    서버 URL 값 return으로 전달

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "accessToken" // 액세스토큰자리
        ]
    }
}
