//
//  ReportServices.swift
//  Join
//
//  Created by 홍정민 on 2022/11/13.
//

import Moya
// 경로케이스별로 열겨헝으로 작성해주기
enum ReportServices {
    case report(param: ReportRequest) //신고
}

//신고
struct ReportRequest: Codable {
    var rendezvousId: Int       // 신고할 번개 ID
    var reportReason: String    // 신고사유(기본)
    var etcDesc: String         // 신고사유(추가내용)
}

//신고 응답
struct ReportResponse: Codable {
    var timestamp: String
    var status: Int
    var message: String
}



extension ReportServices: TargetType {
    var path: String {
        switch self {
        case .report:
            return "/api/v1/report/rendezvous"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .report:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .report(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json", "Authorization":"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjEyLCJleHAiOjE2OTUxMjg1NjN9.Pcmm3VBs-Obdg8WckQS3OHXlSgdYTj5OIOICGQgj_4k"]
            
        }
    }
    
    private var token: String {
        return KeychainHandler.shared.accessToken
    }
    
    public var baseURL: URL {
        return URL(string: Environment.baseUrl)!
    }
}
