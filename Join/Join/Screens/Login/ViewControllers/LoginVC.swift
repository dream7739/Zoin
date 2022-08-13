//
//  ViewController.swift
//  Join
//
//  Created by 이윤진 on 2022/04/20.
//

import UIKit

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

    private let authProvier = MoyaProvider<AuthServices>()

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

        if KeychainHandler.shared.accessToken != "" {
            let time = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: time) {
                let viewController = TabBarController()
                viewController.modalPresentationStyle = .fullScreen
                if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    delegate.window?.rootViewController = viewController
                }
                self.present(viewController, animated: true)
            }
        }



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
        // 카카오톡 설치여부 체크
        //        if (UserApi.isKakaoTalkLoginAvailable()) {
        //            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
        //                if let error = error {
        //                    print(error)
        //                }
        //                else {
        //                    print("loginWithKakaoTalk() success.")
        //
        //                    //do something
        //                    _ = oauthToken
        //                }
        //            }
        //        } else {
        //            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
        //                if let error = error {
        //                    print(error)
        //                }
        //                else {
        //                    print("loginWithKakaoTalk() success.")
        //                    //do something
        //                    _ = oauthToken
        //                }
        //            }
        //        }

        // 지금은 테스트니까 웹 브라우저로 열리는걸로 해봅시다
        // 소셜로그인 login 이후 -> null로 받아와지면 소셜회원가입 진행
        // Userdefault로 kakao인지 apple인지 체크
        // 소문자로
        
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

                        let signUpCheck = didSignUpRequest(accountId: KeychainHandler.shared.kakaoId)
                        self.authProvier.rx.request(.checkKakoLogin(param: signUpCheck))
                            .asObservable()
                            .subscribe(onNext: {[weak self] response in
                                if response.statusCode == 200 {
                                    let message = JSON(response.data)["message"]
                                    print(message)
                                    if message == "소셜 로그인 성공" {
                                        UserDefaults.standard.set("kakao",forKey: "social")
                                        let id = JSON(response.data)["data"]
                                            //["loginRes"]["user"]["id"].string!
                                        print(id)
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
}

