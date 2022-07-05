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

    var accessToken: String {
        get {
            return keychain.string(forKey: accessTokenKey) ?? "Key is empty"
        }
        set {
            keychain.set(newValue, forKey: accessTokenKey)
        }
    }

    var refreshToken: String {
        get {
            return keychain.string(forKey: refreshTokenKey) ?? "key is empty"
        }
        set {
            keychain.set(newValue, forKey: refreshTokenKey)
        }
    }

    var email: String {
        get {
            return keychain.string(forKey: emailKey) ?? "key is empty"
        }
        set {
            keychain.set(newValue, forKey: emailKey)
        }
    }

    var password: String {
        get {
            return keychain.string(forKey: passwordKey) ?? "key is empty"
        }
        set {
            keychain.set(newValue, forKey: passwordKey)
        }
    }

    var serviceId: String {
        get {
            return keychain.string(forKey: serviceIdKey) ?? "key is empty"
        }
        set {
            keychain.set(newValue, forKey: serviceIdKey)
        }
    }

    var username: String {
        get {
            return keychain.string(forKey: usernameKey) ?? "key is empty"
        }
        set {
            keychain.set(newValue, forKey: usernameKey)
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
