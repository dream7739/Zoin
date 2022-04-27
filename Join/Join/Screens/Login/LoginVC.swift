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

    // 로그인 화면 아직 안만들었음
    private let SignInButton = UIButton().then {
        $0.setTitle("이메일 로그인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }

    private let SignUpButton = UIButton().then {
        $0.setTitle("이메일 회원가입", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
    }
}

// 익스텐션에는 레이아웃 그려주는 함수나 액션함수들 한 번에 집어넣는 편 (개인적 습관)
extension LoginVC {
    private func setLayout() {
        view.adds([
            Button,
            SignInButton,
            SignUpButton
        ])
        Button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view).offset(100)
        }
        SignInButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(Button.snp.bottom).offset(60)
        }
        SignUpButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(SignInButton.snp.bottom).offset(7)
        }
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

