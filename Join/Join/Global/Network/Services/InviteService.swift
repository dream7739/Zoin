//
//  InviteService.swift
//  Join
//
//  Created by 홍정민 on 2022/12/17.
//

import Moya
// 경로케이스별로 열겨헝으로 작성해주기

enum InviteServices {
    case me //내 정보 가져오기
}

//내 정보 응답
struct MeResponse: Codable {
    var timestamp: String
    var status: Int
    var message: String
    var data: User
}

struct User : Codable {
    var id:Int
    var serviceId: String
    var userName: String
    var email: String
    var profileImgUrl: String
    var createdAt: String
    var updatedAt: String
}


extension InviteServices: TargetType {
    var path: String {
        switch self {
        case .me:
            return "/api/v1/user/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .me:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .me:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json",
                    "Authorization": token]
            
        }
    }
    
    private var token: String {
        return KeychainHandler.shared.accessToken
    }
    
    public var baseURL: URL {
        return URL(string: Environment.baseUrl)!
    }
}
