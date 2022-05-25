//
//  VerifyEmailVC.swift
//  Join
//
//  Created by 이윤진 on 2022/04/25.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxKeyboard

class VerifyEmailVC: BaseViewController {

    private let titleFirstLabel = UILabel().then {
        $0.text = "입력한 이메일로"
        $0.textColor = .black
    }

    private let titleSecondLabel = UILabel().then {
        $0.text = "인증번호를 보냈어요.🔏"
        $0.textColor = .black
        // $0.font = .systemFont(ofsize: , weight: )
    }

    private let guideLabel = UILabel().then {
        $0.text = "인증번호"
        $0.textColor = .black
    }

    private let verifyTextField = UITextField().then {
        $0.placeholder = "인증번호 6자리"
        $0.tintColor = .black
        $0.backgroundColor = .lightGray
        $0.borderStyle = .roundedRect
        $0.addLeftPadding()
    }

    private let guideButton = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 16
        $0.setTitle("다음", for: .normal)
        // 키보드 엔터 눌렀을대 자동으로 인증되게끔 처리해놓기
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar(isHidden: false)
        setUpNavigation()
    }
}

extension VerifyEmailVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            titleFirstLabel,
            titleSecondLabel,
            guideLabel,
            verifyTextField,
            guideButton
        ])
        titleFirstLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(250)
            make.top.equalToSuperview().offset(8)
        }
        titleSecondLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleFirstLabel.snp.bottom).offset(6)
            make.width.equalTo(250)
            make.leading.equalTo(titleFirstLabel.snp.leading)
        }
        guideLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleSecondLabel.snp.leading)
            make.top.equalTo(titleSecondLabel.snp.bottom).offset(25)
            make.width.equalTo(100)
        }
        verifyTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(guideLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(guideLabel.snp.bottom).offset(9)
            make.width.equalTo(327)
            make.height.equalTo(56)
        }
        guideButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-30)
            make.width.equalTo(327)
            make.height.equalTo(56)
        }
    }

    private func setUpNavigation() {
        title = "회원가입"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationBar.isHidden = false
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
    }

    private func bind() {
        guideButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let viewController = RegisterPasswordVC()
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)

        RxKeyboard.instance.visibleHeight.drive(onNext: {[weak self] keyboardHeight in
            guard let self = self else { return }
            UIView.animate(withDuration: 0) {
                if keyboardHeight == 0 {
                    self.guideButton.snp.updateConstraints { make in
                        make.bottom.equalToSuperview().offset(-30)
                    }
                } else {
                    let totalHeight = keyboardHeight - self.view.safeAreaInsets.bottom
                    self.guideButton.snp.updateConstraints { (make) in
                        make.bottom.equalToSuperview().offset(-totalHeight+(-60))
                    }
                }
                self.view.layoutIfNeeded()
            }
        })
            .disposed(by: disposeBag)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
