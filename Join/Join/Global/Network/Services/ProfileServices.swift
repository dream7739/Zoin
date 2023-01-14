//
//  ProfileServices.swift
//  Join
//
//  Created by 이윤진 on 2022/07/18.
//

import Foundation

import Moya

enum ProfileServices {
    case searchFriendsId(id: String)
    case getFriendsList
    case getParticipatedHistory(isClosed: String)
    case getCreatedHistory(isClosed: String)
    case changeImage(image: UIImage)
    case addFriend(param: userId)
    case deleteFriend(Int)
    case invitation(param: friendId)
}

struct searchIdRequest: Encodable {
    var searchInput: String
}

struct tokenRequest: Encodable {
    var Authorization: String
}

// MARK: - data 구조 옮기기
struct user: Codable {
    var id:Int
    var serviceId: String
    var userName: String
    var email: String
    var profileImgUrl: String
    var createdAt: String
    var updatedAt: String
}
struct userData: Codable {
    var user: creater
    var relationshipOrder: Int
}

struct meetingData: Codable {
    var id: Int
    var creater: creater
    var title: String
    var location: String
    var appointmentTime: String
    var requiredParticipantsCount: Int
    var createdAt: String
    var updatedAt: String
    var participantCnt: Int
    var description: String
}

struct creater: Codable {
    var id: Int
    var serviceId: String
    var userName: String
    var email: String
    var profileImgUrl: String
    var createdAt: String
    var updatedAt: String
}

struct userId: Codable {
    var targetUserId: Int
}

struct friendId: Codable {
    var invitingFriendId: Int
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
        case .getFriendsList:
            return "/api/v1/user/friends"
        case .getParticipatedHistory:
            return "/api/v1/user/rendezvous/participated"
        case .getCreatedHistory(isClosed: let isClosed):
            return "/api/v1/user/rendezvous/created"
        case .changeImage:
            return "/api/v1/user/profile/demo"
        case .addFriend:
            return "/api/v1/friend"
        case .deleteFriend(let id):
            return "/api/v1/user/friends/\(id)"
        case .invitation:
            return "/api/v1/friend/invitation"
        }
    }

    var method: Moya.Method {
        switch self {
        case .searchFriendsId:
            return .get
        case .getFriendsList:
            return .get
        case .getParticipatedHistory:
            return .get
        case .getCreatedHistory:
            return .get
        case .changeImage:
            return .put
        case .addFriend:
            return .post
        case .deleteFriend:
            return .delete
        case .invitation:
            return .put
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case.searchFriendsId(id: let id):
            return .requestParameters(parameters: ["searchInput": id], encoding: URLEncoding.queryString)
        case .getFriendsList:
            return .requestPlain
        case .getParticipatedHistory(isClosed: let isClosed):
            return .requestParameters(parameters: ["isClosed": isClosed], encoding: URLEncoding.queryString)
        case .getCreatedHistory(isClosed: let isClosed):
            return .requestParameters(parameters: ["isClosed": isClosed], encoding: URLEncoding.queryString)
        case .changeImage(image: let image):
            var multipartData: [MultipartFormData] = []
            if image != UIImage(){
                let imageData = MultipartFormData(provider: .data(image.resized(withPercentage: 0.5)?.jpegData(compressionQuality: 0.0) ?? Data()), name: "file", fileName: "file", mimeType: "image/jpg")
                multipartData.append(imageData)
            } else {
                multipartData.append(.init(provider: .data(Data()), name: "file", fileName: "file"))
            }
            return .uploadMultipart(multipartData)
        case .addFriend(let param):
            return .requestJSONEncodable(param)
        case .deleteFriend(_):
            return .requestPlain
        case .invitation(let param):
            return .requestJSONEncodable(param)
        }
    }

    var headers: [String : String]? {
        switch self {
        case .changeImage:
            return ["Content-Type": "multipart/form-data",
                    "Authorization": token]
        default:
            return ["Content-Type": "application/json",
                    "Authorization": token]
        }
    }


}
