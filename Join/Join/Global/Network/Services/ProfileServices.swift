//
//  ProfileServices.swift
//  Join
//
//  Created by 이윤진 on 2022/07/18.
//

import Foundation

import Moya

enum ProfileServices {
    case searchFriendsId(param: searchIdRequest)
}

struct searchIdRequest: Encodable {
    var searchInput: String
}

extension ProfileServices: TargetType {
    private var token: String {
        return KeychainHandler.shared.accessToken
    }
    var baseURL: URL {
        return URL(string: Environment.baseUrl)!
    }


    var path: String {
        switch self {
        case .searchFriendsId:
            return "/api/v1/user"
        }
    }

    var method: Moya.Method {
        switch self {
        case .searchFriendsId:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case.searchFriendsId(let param):
            return .requestJSONEncodable(param)
        }
    }

    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json",
                    "Authorization": token]
        }
    }


}
