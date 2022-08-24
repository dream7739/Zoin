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
    case participant(id: Int) //번개 참여
    case deleteParticipant(id: Int) //번개 참여 취소
    case participants(id: Int) //번개 참여자 목록보기
    case close(id: Int) //번개 마감
    case current //홈 상단 날씨 조회
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
    var whetherUserParticipateOrNot: Bool?
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

//참여자 확인 응답
struct ParticipantResponse: Codable {
    var timestamp: String
    var status: Int
    var message: String
    var data: [MainProfileResponse]
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
        case .participant(let id), .deleteParticipant(let id):
            return "/api/v1/rendezvous/\(id)/participant"
        case .participants(let id):
            return "/api/v1/rendezvous/\(id)/participants"
        case .close(let id):
            return "/api/v1/rendezvous/\(id)/close"
        case .current:
            return "/api/v1/rendezvous/current"
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
        case .main, .participants:
            return .get
        case .participant:
            return .post
        case .deleteParticipant:
            return .delete
        case .close:
            return .patch
        case .current:
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
        case .participant(let param):
            return .requestJSONEncodable(param)
        case .deleteParticipant(let param):
            return .requestJSONEncodable(param)
        case .participants:
            return .requestPlain
        case .close:
            return .requestPlain
        case .current:
            return .requestPlain
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
