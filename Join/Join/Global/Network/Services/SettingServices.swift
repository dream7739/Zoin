//
//  SettingServices.swift
//  Join
//
//  Created by 이윤진 on 2022/08/04.
//

import Foundation

import Moya

enum SettingServices {
    case changePassword(param: password)
}

struct password: Codable {
    var password: String
    var newPassword: String
}

extension SettingServices: TargetType {
    var baseURL: URL {
        return URL(string: Environment.baseUrl)!
    }

    private var token: String{
        return KeychainHandler.shared.accessToken
    }
    var path: String {
        switch self {
        case .changePassword:
            return "/api/v1/user/password"
        }
    }

    var method: Moya.Method {
        switch self {
        case.changePassword:
            return .put
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task:Task {
        switch self {
        case.changePassword(let param):
            return .requestJSONEncodable(param)
        }
    }

    var headers: [String : String]? {
        switch self {
        default:
            return[
                "Content-Type":"application/json",
                "Authorization": token]
        }
    }
}
