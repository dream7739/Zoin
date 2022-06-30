//
//  RegsiterPasswordVC.swift
//  Join
//
//  Created by 이윤진 on 2022/04/25.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift
import RxKeyboard

class RegisterPasswordVC: BaseViewController {

    private let titleFirstLabel = UILabel().then {
        $0.text = "비밀번호를 입력해 주세요.✍️"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let guideFirstLabel = UILabel().then {
        $0.text = "비밀번호 입력"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }

    private let addPasswordTextField = UITextField().then {
        $0.placeholder = "8자 이상 12자 이하"
        $0.setPlaceHolderColor(.grayScale600)
        $0.tintColor = .yellow200
        $0.textColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
        $0.addLeftPadding()
    }

    private let addPasswordLabel = UILabel().then {
        // 일치한다면 사용 가능한 비밀번호입니다. 파란색으로 변경
        $0.text = "8자 이상 12자 이하"
        $0.textColor = .red100
        $0.font = .minsans(size: 12, family: .Medium)
    }

    private let guideSecondLabel = UILabel().then {
        $0.text = "비밀번호 확인"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }

    private let verifyPasswordTextField = UITextField().then {
        $0.placeholder = "최소 8자 이상"
        $0.setPlaceHolderColor(.grayScale600)
        $0.tintColor = .yellow200
        $0.textColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
        $0.addLeftPadding()
    }

    private let verifyPasswordLabel = UILabel().then {
        $0.text = "비밀번호가 일치하지 않습니다."
        $0.textColor = .red100
        $0.font = .minsans(size: 12, family: .Medium)

    }

    private let guideButton = UIButton().then {
        $0.backgroundColor = .yellow200
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.layer.cornerRadius = 16
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
        // 사용가능한 이메일일때
        // isEnabled, isSelected 설정해놓기
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

extension RegisterPasswordVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            titleFirstLabel,
            guideFirstLabel,
            addPasswordTextField,
            addPasswordLabel,
            guideSecondLabel,
            verifyPasswordTextField,
            verifyPasswordLabel,
            guideButton
        ])
        titleFirstLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(24)
        }
        guideFirstLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleFirstLabel.snp.bottom).offset(25)
            make.leading.equalTo(titleFirstLabel.snp.leading)
            make.width.equalTo(100)
        }
        addPasswordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(guideFirstLabel.snp.bottom).offset(9)
            make.leading.equalTo(guideFirstLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(327)
            make.height.equalTo(56)
        }
        addPasswordLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addPasswordTextField.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(41)
            make.width.equalTo(250)
        }
        guideSecondLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addPasswordLabel.snp.bottom).offset(17)
            make.leading.equalTo(addPasswordTextField.snp.leading)
            make.width.equalTo(150)
        }
        verifyPasswordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(guideSecondLabel.snp.bottom).offset(9)
            make.leading.equalTo(guideSecondLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(327)
            make.height.equalTo(56)
        }
        verifyPasswordLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(41)
            make.top.equalTo(verifyPasswordTextField.snp.bottom).offset(4)
            make.width.equalTo(200)
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
        addPasswordTextField.rx.text
            .do { [weak self] text in
                guard let self = self,
                      let text = text
                else { return}
                if text.count > 0 {
                    self.addPasswordTextField.layer.borderColor = UIColor.grayScale400.cgColor
                    self.addPasswordTextField.layer.cornerRadius = 20
                    self.addPasswordTextField.layer.borderWidth = 2.0
                } else {
                    self.addPasswordTextField.layer.borderWidth = 0.0
                }
            }
            .subscribe(onNext: { [weak self] _ in
                // guard let self = self else { return }
            })
            .disposed(by: disposeBag)

        verifyPasswordTextField.rx.text
            .do { [weak self] text in
                guard let self = self,
                      let text = text
                else { return}
                if text.count > 0 {
                    self.verifyPasswordTextField.layer.borderColor = UIColor.grayScale400.cgColor
                    self.verifyPasswordTextField.layer.cornerRadius = 20
                    self.verifyPasswordTextField.layer.borderWidth = 2.0
                } else {
                    self.verifyPasswordTextField.layer.borderWidth = 0.0
                }
            }
            .subscribe(onNext: { [weak self] _ in
                // guard let self = self else { return }
            })
            .disposed(by: disposeBag)

        guideButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let viewController = RegisterNicknameVC()
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)

        RxKeyboard.instance.visibleHeight.drive(onNext: {[weak self] keyboardHeight in
            guard let self = self else { return }
            UIView.animate(withDuration: 0) {
                if keyboardHeight == 0 {
                    self.guideButton.layer.cornerRadius = 16
                    self.guideButton.snp.updateConstraints { make in
                        make.leading.equalToSuperview().offset(24)
                        make.trailing.equalToSuperview().offset(-24)
                        make.bottom.equalToSuperview().offset(-30)
                    }
                } else {
                    self.guideButton.layer.cornerRadius = 0
                    let totalHeight = keyboardHeight - self.view.safeAreaInsets.bottom
                    self.guideButton.snp.updateConstraints { (make) in
                        make.leading.equalToSuperview().offset(0)
                        make.trailing.equalToSuperview().offset(0)
                        make.bottom.equalToSuperview().offset(-totalHeight+(-30))
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
