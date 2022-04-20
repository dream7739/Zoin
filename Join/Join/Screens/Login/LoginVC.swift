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
    private let LoginButton = UIButton().then {
        $0.setTitle("메인으로", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
        // Do any additional setup after loading the view.
    }
}

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

