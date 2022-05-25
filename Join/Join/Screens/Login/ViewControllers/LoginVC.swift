//
//  ViewController.swift
//  Join
//
//  Created by 이윤진 on 2022/04/20.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift

class LoginVC: BaseViewController {

    private let Button = UIButton().then {
        $0.setTitle("임시버튼/메인으로", for: .normal)
        $0.setTitleColor(.black, for: .normal)
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
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }
    private let SignUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.grayScale100, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
    }

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
            make.trailing.equalToSuperview().offset(-110)
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
    private func bind() {
        // Rx 적용시 input, output 연결하는부분
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
    }
}

