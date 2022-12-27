//
//  AuthServices.swift
//  Join
//
//  Created by 이윤진 on 2022/06/27.
//

import Foundation

import Moya
// 경로케이스별로 열겨헝으로 작성해주기
enum AuthServices {
    case signUp(param: SignUpRequest)
    case signIn(param: SignInRequest )
    case checkId(param: checkId)
    case checkEmail(param: checkEmail)
    case verifyEmail(param: verifyEmail)
    case checkCode(param: checkCode )
    case kakaoLogin(param: SocialSignUpRequest)
    case checkKakoLogin(param: didSignUpRequest)
    case appleLogin(param: SocialSignUpRequest)
    case checkAppleLogin(param: didSignUpRequest)
    case addFcmToken(param: fcmToken)
    case deleteFcmToken
}
// MARK: - parameter data
// 모델데이터 global 파일에 data 하위디렉터리 만들어서 옮기는게 낫지 않을까?
// 일단은 한 파일내에 한꺼번에 작성함. 근데 수정 필요할듯
struct SignUpRequest: Encodable {
    var userName: String
    var email: String
    var password: String
    var serviceId: String
    var profileImgUrl: String
}

struct SocialSignUpRequest: Encodable {
    var id: String
    var email: String
    var userName: String
    var serviceId: String
    var profileImgUrl: String
}

struct SignInRequest: Encodable {
    var email: String
    var password: String
}

struct checkId: Encodable {
    var serviceId: String
}

struct checkEmail: Encodable {
    var email: String
}

struct verifyEmail: Encodable {
    var email: String
}

struct checkCode: Encodable {
    var email: String
    var code: String
}

struct didSignUpRequest: Encodable {
    var accountId: String
}

struct fcmToken: Encodable {
    var token: String
}

extension AuthServices: TargetType {
    // MARK: - 키체인라이브러리 추가 필요
    // 토큰 관련 작업 시 주석 해제
    private var token: String {
        return KeychainHandler.shared.accessToken
    }

    var baseURL: URL {
        return URL(string: Environment.baseUrl)!
    }
    // API 별로 경로 설정 (케이스 단위로 접근 가능)
    // baseURL 기준으로 이어서 작성해주면 됩니다.
    var path: String {
        switch self {
        case .signUp:
            return "/api/v1/user/sign-up"
        case .signIn:
            return "/api/v1/user/log-in"
        case .checkId:
            return "/api/v1/user/existing/id"
        case .checkEmail:
            return "/api/v1/user/existing/email"
        case .verifyEmail:
            return "/api/v1/user/verification"
        case .checkCode:
            return "/api/v1/email-auth"
        case .kakaoLogin:
            return "/api/v1/user/sign-up/kakao"
        case .checkKakoLogin:
            return "/api/v1/user/log-in/kakao"
        case .appleLogin:
            return "/api/v1/user/sign-up/apple"
        case .checkAppleLogin:
            return "/api/v1/user/log-in/apple"
        case .addFcmToken:
            return "/api/v1/notification"
        case .deleteFcmToken:
            return "/api/v1/notification"
        }
    }

    // 어떤 호출방법인지 각 경로별로 선언해줌
    var method: Moya.Method {
        switch self {
        case .signUp:
            return .post
        case .signIn:
            return .post
        case .checkId:
            return .post
        case .checkEmail:
            return .post
        case .verifyEmail:
            return .post
        case .checkCode:
            return .patch
        case .kakaoLogin:
            return .post
        case .checkKakoLogin:
            return .post
        case .appleLogin:
            return .post
        case .checkAppleLogin:
            return .post
        case .addFcmToken:
            return .patch
        case .deleteFcmToken:
            return .delete
        }
    }

    // 이거는 받아오는 data의 디폴트값이라고 봐주면 됩니다
    // 템플릿처럼 만들어지는 친구
    var sampleData: Data {
        return Data()
    }

    // 어떻게 데이터를 보내주고 받아오는지 설정하는 부분
    // 리턴값 정의파일로 들어가보면 각 형식에 맞는 케이스들이 나열되어있음!
    // 내가 쓴 requestJSONEncodable은 post에서 바디값만 보내주는거라서 요렇게 보내주는중
    var task: Task {
        switch self {
        case.signUp(let param):
            return .requestJSONEncodable(param)
        case .signIn(let param):
            return .requestJSONEncodable(param)
        case .checkId(let param):
            return .requestJSONEncodable(param)
        case .checkEmail(let param):
            return .requestJSONEncodable(param)
        case .verifyEmail(let param):
            return .requestJSONEncodable(param)
        case .checkCode(let param):
            return .requestJSONEncodable(param)
        case .kakaoLogin(let param):
            return .requestJSONEncodable(param)
        case .checkKakoLogin(let param):
            return .requestJSONEncodable(param)
        case .appleLogin(param: let param):
            return .requestJSONEncodable(param)
        case .checkAppleLogin(param: let param):
            return .requestJSONEncodable(param)
        case .addFcmToken(let param):
            return .requestJSONEncodable(param)
        case .deleteFcmToken:
            return .requestPlain
        }
    }

    // 헤더파일 구성하는부분
    var headers: [String : String]? {
        switch self {
        case .addFcmToken, .deleteFcmToken:
            return ["Content-Type": "application/json", "Authorization": token]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
