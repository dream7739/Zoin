//
//  KeychainHandler.swift
//  Join
//
//  Created by 이윤진 on 2022/07/05.
//

import SwiftKeychainWrapper

struct KeychainHandler {
    static var shared = KeychainHandler()
    init() {}

    private let keychain = KeychainWrapper.standard
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let emailKey = "email"
    private let passwordKey = "password"
    private let serviceIdKey = "serviceId"
    private let usernameKey = "username"
    private let profileImgUrlKey = "profileImgUrl"
    private let kakaoIdkey = "kakaoId"
    private let friendCountkey = "friendCountkey"
    private let appleIdkey = "appleId"

    var accessToken: String {
        get {
            return keychain.string(forKey: accessTokenKey) ?? ""
        }
        set {
            keychain.set(newValue, forKey: accessTokenKey)
        }
    }

    var refreshToken: String {
        get {
            return keychain.string(forKey: refreshTokenKey) ?? ""
        }
        set {
            keychain.set(newValue, forKey: refreshTokenKey)
        }
    }

    var email: String {
        get {
            return keychain.string(forKey: emailKey) ?? ""
        }
        set {
            keychain.set(newValue, forKey: emailKey)
        }
    }

    var password: String {
        get {
            return keychain.string(forKey: passwordKey) ?? ""
        }
        set {
            keychain.set(newValue, forKey: passwordKey)
        }
    }

    var serviceId: String {
        get {
            return keychain.string(forKey: serviceIdKey) ?? ""
        }
        set {
            keychain.set(newValue, forKey: serviceIdKey)
        }
    }

    var username: String {
        get {
            return keychain.string(forKey: usernameKey) ?? ""
        }
        set {
            keychain.set(newValue, forKey: usernameKey)
        }
    }

    var profileImgUrl: String {
        get {
            return keychain.string(forKey: profileImgUrlKey) ?? ""
        }
        set {
            keychain.set(newValue, forKey: profileImgUrl)
        }
    }

    var kakaoId: String {
        get {
            return keychain.string(forKey: kakaoIdkey) ?? ""
        }
        set {
            keychain.set(newValue, forKey: kakaoIdkey)
        }
    }

    var appleId: String {
        get {
            return keychain.string(forKey: appleIdkey) ?? ""
        }
        set {
            keychain.set(newValue, forKey: appleIdkey)
        }
    }

    var friendCount: Int {
        get {
            return keychain.integer(forKey: friendCountkey) ?? 0
        }
        set {
            keychain.set(newValue, forKey: friendCountkey)
        }
    }

    func logout() {
        keychain.remove(forKey: KeychainWrapper.Key(rawValue: accessTokenKey))
        keychain.remove(forKey: KeychainWrapper.Key(rawValue: refreshTokenKey))
        keychain.remove(forKey: KeychainWrapper.Key(rawValue: emailKey))
        keychain.remove(forKey: KeychainWrapper.Key(rawValue: passwordKey))
        keychain.remove(forKey: KeychainWrapper.Key(rawValue: serviceIdKey))
        keychain.remove(forKey: KeychainWrapper.Key(rawValue: usernameKey))
    }

    func removeAllKeys() {
        keychain.removeAllKeys()
    }
}
