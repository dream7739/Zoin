//
//  AuthServices.swift
//  Join
//
//  Created by 이윤진 on 2022/06/25.
//

import Foundation

import Moya

enum AuthServices {
    case signUp(param: SignUpRequest)
}

struct SignUpRequest: Encodable {
    var userName: String
    var email: String
    var password: String
    var serviceId: String
    var profileImgUrl: String
}

extension AuthServices: TargetType {
    // MARK: - 키체인라이브러리 추가 필요
    // private var token: String {
    //  return KeychainHandler.shared.accessToken
    // }
    var path: String {
        switch self {
        case .signUp:
            return "/api/v1/user/sign-up"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signUp:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case.signUp(let param):
            return .requestJSONEncodable(param)
        }
    }

    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }

    public var baseURL: URL {
        return URL(string: Environment.baseUrl)!
    }
}
