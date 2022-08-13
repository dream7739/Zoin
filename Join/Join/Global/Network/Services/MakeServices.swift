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
    case rendezvous(param: MakeRequest) //번개 생성
    case modifyRendezvous(id: Int, param: MakeRequest) //번개 수정
    case deleteRendezvous(id: Int) //번개 삭제
    case main(size: Int, cursor: Int?) //번개 메인
}

//번개 생성
struct MakeRequest: Codable {
    var title: String
    var appointmentTime: String
    var location: String
    var requiredParticipantsCount: String
    var description: String
}

//번개 생성 응답
struct MakeResponse: Codable {
    var timestamp: String
    var status: Int
    var message: String
    var data: MainElements
}


//번개 메인리스트 조회 요청
struct MainRequest: Codable {
    var size: Int
}

//번개 메인리스트 조회 응답
struct MainResponse: Codable {
    var timestamp: String
    var status: Int
    var message: String
    var data: MainData
}

struct MainData: Codable {
    var elements: [MainElements]
    var hasNext: Bool
}

struct MainElements: Codable {
    var id: Int
    var creator: MainProfileResponse
    var title: String
    var appointmentTime: String
    var location: String
    var requiredParticipantsCount: Int
    var createdAt:String
    var updatedAt:String
    var participants:[MainProfileResponse]?
    var description:String
    var isMyRendezvous: Bool?
}

struct MainProfileResponse : Codable {
    var id: Int
    var serviceId: String
    var userName: String
    var email: String
    var profileImgUrl: String
    var createdAt: String
    var updatedAt: String
}



extension MakeServices: TargetType {
    var path: String {
        switch self {
        case .rendezvous:
            return "/api/v1/rendezvous"
        case .modifyRendezvous(let id, _), .deleteRendezvous(let id):
            return "/api/v1/rendezvous/\(id)"
        case .main:
            return "/api/v1/rendezvous/main"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .rendezvous:
            return .post
        case .modifyRendezvous:
            return .put
        case .deleteRendezvous:
            return .delete
        case .main:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .rendezvous(let param):
            return .requestJSONEncodable(param)
        case .modifyRendezvous(_, let param):
            return .requestJSONEncodable(param)
        case .deleteRendezvous(let param):
            return .requestJSONEncodable(param)
        case .main(let size, let cursor):
            return .requestParameters(parameters: ["size" : size, "cursor" : cursor ?? ""], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json", "Authorization":"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjcsImV4cCI6MTY4OTA3MjI2Nn0.wMDxjSs00pe-ngLyAyUeQ6BPiuyRUfHZHxHh3ALWcB0"]
        }
    }
    
    public var baseURL: URL {
        return URL(string: Environment.baseUrl)!
    }
}
