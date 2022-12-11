//
//  ViewController.swift
//  Join
//
//  Created by 이윤진 on 2022/04/20.
//

import UIKit

import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import SnapKit
import SwiftyJSON
import Then
import RxCocoa
import RxSwift
import Moya

class LoginVC: BaseViewController {

    private let Button = UIButton().then {
        $0.setTitle("임시버튼/메인으로", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    private let logoImage = UIImageView().then {
        $0.image = Image.logo
    }
    private let guideImage = UIImageView().then {
        $0.image = Image.speechBubble
    }
    private let kakaoButton = UIButton().then {
        $0.setImage(Image.kakaoBtn, for: .normal)
    }
    private let appleButton = UIButton().then {
        $0.setImage(Image.appleBtn, for: .normal)
    }
    // 로그인 화면 아직 안만들었음
    private let SignInButton = UIButton().then {
        $0.setTitle("이메일 로그인", for: .normal)
        $0.setTitleColor(.grayScale100, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
    }
    private let divideLabel = UILabel().then {
        $0.text = "|"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Regular)
    }
    private let SignUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.grayScale100, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
    }

    var kakaoId: String?

    private let authProvider = MoyaProvider<AuthServices>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigation()
        setLeftBarButton()
    }
}

// 익스텐션에는 레이아웃 그려주는 함수나 액션함수들 한 번에 집어넣는 편 (개인적 습관)
extension LoginVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            Button,
            logoImage,
            guideImage,
            kakaoButton,
            appleButton,
            SignInButton,
            divideLabel,
            SignUpButton
        ])
        // 나중에 화면연결 다 끝내고 없애버리기
        Button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view).offset(100)
        }
        logoImage.snp.makeConstraints { (make) in
            make.top.equalTo(Button.snp.bottom).offset(110)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(101)
        }
        guideImage.snp.makeConstraints { (make) in
            make.top.equalTo(logoImage.snp.bottom).offset(165)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(106)
        }
        kakaoButton.snp.makeConstraints { (make) in
            make.top.equalTo(guideImage.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
        }
        appleButton.snp.makeConstraints { (make) in
            make.top.equalTo(kakaoButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
        }
        SignUpButton.snp.makeConstraints { (make) in
            make.top.equalTo(appleButton.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(110)
        }
        divideLabel.snp.makeConstraints { (make) in
            make.top.equalTo(appleButton.snp.bottom).offset(40)
            make.leading.equalTo(SignUpButton.snp.trailing).offset(12)
        }
        SignInButton.snp.makeConstraints { (make) in
            make.top.equalTo(appleButton.snp.bottom).offset(36)
            make.leading.equalTo(divideLabel.snp.trailing).offset(14)
        }
    }

    private func setUpNavigation() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationBar.isHidden = true
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationItem.hidesBackButton = true
    }

    // MARK: - RX 사용안하니까 이 부분 수정 필요합니다
    private func bind() {
        kakaoButton.addTarget(self, action: #selector(didTapKakao), for: .touchUpInside)
        appleButton.addTarget(self, action: #selector(didTapApple), for: .touchUpInside)
        Button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let viewController = TabBarController()
                viewController.modalPresentationStyle = .fullScreen
                if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    delegate.window?.rootViewController = viewController
                }
                self.present(viewController, animated: false)
            })
            .disposed(by: disposeBag)

        SignUpButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let viewController = RegisterEmailVC()
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)

        SignInButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let viewController = EmailLoginVC()
            self.navigationController?.pushViewController(viewController, animated: true)
        })
        .disposed(by: disposeBag)
    }

    @objc func didTapKakao() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                UserApi.shared.me { (user, error) in
                    if let error = error {
                        print(error)
                    } else {
                        // 카카오 이메일 수집해서 저장완료하기
                        guard let email = user?.kakaoAccount?.email else { return }
                        if let id = user?.id {
                            self.kakaoId = String(id)
                        }
                        let userEmail = String(email)
                        // 기기변경 후 처음 로그인하는거 생각해서 accountId 파라미터 self.kakaoId로 변경
                        // keychainhandler값도 새로 갱신해주기?
                        let signUpCheck = didSignUpRequest(accountId: KeychainHandler.shared.kakaoId)
                        self.authProvider.rx.request(.checkKakoLogin(param: signUpCheck))
                            .asObservable()
                            .subscribe(onNext: {[weak self] response in
                                if response.statusCode == 200 {
                                    let message = JSON(response.data)["message"]
                                    print(JSON(response.data)["data"])
                                    print(message)
                                    if message == "소셜 로그인 성공" {
                                        UserDefaults.standard.set("kakao",forKey: "social")
                                        let token = JSON(response.data)["data"]["loginRes"]["accessToken"]
                                        let user = JSON(response.data)["data"]["loginRes"]["user"]
                                        let friendsCount = JSON(response.data)["data"]["loginRes"]["friendCount"]
                                        KeychainHandler.shared.accessToken = token.string!
                                        KeychainHandler.shared.serviceId = user["serviceId"].string!
                                        KeychainHandler.shared.username = user["userName"].string!
                                        KeychainHandler.shared.email = user["email"].string!
                                        KeychainHandler.shared.profileImgUrl = user["profileImgUrl"].string!
                                        KeychainHandler.shared.friendCount = friendsCount.intValue
                                        print(token)
                                        print(user["serviceId"])
                                        // 로그인완료로 메인으로 바로 이동시키기
                                        let viewController = TabBarController()
                                        viewController.modalPresentationStyle = .fullScreen
                                        self?.present(viewController, animated: true)
                                    }
                                    if message == "가입되지 않은 소셜 계정입니다." {
                                        UserDefaults.standard.set("kakao",forKey: "social")
                                        KeychainHandler.shared.email = userEmail
                                        KeychainHandler.shared.kakaoId = self?.kakaoId ?? ""
                                        let viewController = RegisterNicknameVC()
                                        self?.navigationController?.pushViewController(viewController, animated: true)
                                    }
                                }
                            }, onError: {[weak self] _ in
                                print("server error")
                            }, onCompleted: {

                            }).disposed(by: self.disposeBag)

                    }
                }
                //do something
                _ = oauthToken
            }
        }
    }

    @objc func didTapApple(){
        let appleIdRequest = ASAuthorizationAppleIDProvider().createRequest()
        appleIdRequest.requestedScopes = [.email, .fullName]

        let controller = ASAuthorizationController(authorizationRequests: [appleIdRequest])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension LoginVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            let signUpCheck = didSignUpRequest(accountId: KeychainHandler.shared.appleId)
            // email : appleIDCredential.email
            // user : appleIDCredential.user 이게 고유값이라서 이거 써야할듯 (id)

            print("User ID : \(appleIDCredential.user)")
            print("User Email : \(appleIDCredential.email ?? "")")

            self.authProvider.rx.request(.checkAppleLogin(param: signUpCheck))
                .asObservable()
                .subscribe(onNext: { [weak self] response in
                    guard let self = self else { return }
                    if response.statusCode == 200 {
                        let message = JSON(response.data)["message"]
                        print(JSON(response.data)["data"])
                        print(message)
                        if message == "소셜 로그인 성공" {
                            UserDefaults.standard.set("apple",forKey: "social")
                            let token = JSON(response.data)["data"]["loginRes"]["accessToken"]
                            let user = JSON(response.data)["data"]["loginRes"]["user"]
                            let friendsCount = JSON(response.data)["data"]["loginRes"]["friendCount"]
                            KeychainHandler.shared.accessToken = token.string!
                            KeychainHandler.shared.serviceId = user["serviceId"].string!
                            KeychainHandler.shared.username = user["userName"].string!
                            KeychainHandler.shared.email = user["email"].string!
                            KeychainHandler.shared.profileImgUrl = user["profileImgUrl"].string!
                            KeychainHandler.shared.friendCount = friendsCount.intValue
                            print(token)
                            print(user["serviceId"])
                            // 로그인완료로 메인으로 바로 이동시키기
                            let viewController = TabBarController()
                            viewController.modalPresentationStyle = .fullScreen
                            self.present(viewController, animated: true)
                        } else if message == "가입되지 않은 소셜 계정입니다." {
                            UserDefaults.standard.set("apple",forKey: "social")
                            KeychainHandler.shared.email = appleIDCredential.email ?? ""
                            KeychainHandler.shared.appleId = appleIDCredential.user
                            let viewController = RegisterNicknameVC()
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                    }
                }, onError: { [weak self] _ in
                    print("server error")
                }).disposed(by: disposeBag)
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password

            print(username, password)
            //Navigate to other view controller
        }
    }
}

extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
