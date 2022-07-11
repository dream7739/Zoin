//
//  MakeService.swift
//  Join
//
//  Created by 홍정민 on 2022/07/07.
//

import Foundation

import Moya
// 경로케이스별로 열겨헝으로 작성해주기
enum MakeServices {
    case rendezvous(param: MakeRequest)
}


struct MakeRequest: Encodable {
    var title: String
    var appointmentTime: String
    var location: String
    var requiredParticipantsCount: String
    var description: String
}


extension MakeServices: TargetType {
    var path: String {
        switch self {
        case .rendezvous:
            return "/api/v1/rendezvous"
        }
    }

    var method: Moya.Method {
        switch self {
        case .rendezvous:
            return .post
    
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case.rendezvous(let param):
            return .requestJSONEncodable(param)
        }
    }

    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json", "Authorization":""]
        }
    }

    public var baseURL: URL {
        return URL(string: Environment.baseUrl)!
    }
}
