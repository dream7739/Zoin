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
    // BaseViewController를 따로 만들어서
    // 네비게이션 처리나, 화면배경색 처리를 미리 해놓을 수 있음
    // UI 관련 요소 추가
    private let LoginButton = UIButton().then {
        $0.setTitle("메인으로", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }

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
        view.addSubview(LoginButton)
        LoginButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view).offset(100)
        }
    }

    private func bind() {
        // Rx 적용시 input, output 연결하는부분
        LoginButton.rx.tap
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
    }
}

