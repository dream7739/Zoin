//
//  AlarmServices.swift
//  Join
//
//  Created by 홍정민 on 2023/01/29.
//


import Moya

enum AlarmServices {
    case list //알림 리스트
}

//내 정보 응답
struct AlarmListResponse: Codable {
    var timestamp: String
    var status: Int
    var message: String
    var data: [Alarm]
}

//알림 타입별 구분 숫자
//1: 새로운 번개
//- 대상: 번개 작성자 친구, 이동: 번개 상세
//2: 참여한 번개 마감
//- 대상: 번개 참여자, 이동: 참여 번개 리스트
//3: 등록한 번개 마감
//- 대상: 번개 작성자, 이동: 내프로필 - 마감한 번개 리스트뷰
//4: 번개 참여
//- 대상: 번개 작성자, 이동: 번개 상세 - 참여자 목록 모달
//5: 번개 참여
//- 대상: 번개 참여자, 이동: 내 프로필 - 참여 번개 리스트뷰
//6: 친구 신청 요청
//- 대상: 신청 받은 유저, 이동: 유저 프로필 - 자동 친구 수락
//7: 친구 신청 수락
//- 대상: 신청한 유저, 이동: 친구 유저 프로필

struct Alarm : Codable {
    var notificationTypeNumber:Int       //알림 구분 숫자
    var notiType: String                //어떤 알림인지 구분함, RENDEZVOUS 또는 FRIEND_REQ 만 있음
    var createdAt: String               //알림 생성 시간
    var message: String                 //알림 메시지
    var rendezvousId: Int?              //번개ID
    var friendUserId: Int?              //친구ID(친구 신청일 경우 신청인ID, 수락일 경우 수락자ID
}


extension AlarmServices: TargetType {
    var path: String {
        switch self {
        case .list:
            return "/api/v1/notification/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .list:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .list:
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
        //return KeychainHandler.shared.accessToken
        return "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjcsImV4cCI6MTcwNTYzODg4M30.cimE60xenAEs1br9PVr-w5y-2ppyRNvHcKFRTUbwmDc"
    }
    
    public var baseURL: URL {
        return URL(string: Environment.baseUrl)!
    }
}
