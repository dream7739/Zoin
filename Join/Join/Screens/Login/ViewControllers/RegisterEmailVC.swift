//
//  RegsiterEmailVC.swift
//  Join
//
//  Created by 이윤진 on 2022/04/25.
//

import UIKit

import SnapKit
import SwiftyJSON
import SwiftKeychainWrapper
import Then
import RxCocoa
import RxSwift
import RxKeyboard
import Moya

class RegisterEmailVC: BaseViewController {

    private let titleFirstLabel = UILabel().then {
        $0.text = "로그인할 때 필요한"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let titleSecondLabel = UILabel().then {
        $0.text = "이메일을 입력해 주세요. ✉️"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let guideLabel = UILabel().then {
        $0.text = "이메일"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }
    private let emailTextField = UITextField().then {
        $0.placeholder = "bungae@buangae.com"
        $0.setPlaceHolderColor(.grayScale600)
        $0.tintColor = .yellow200
        $0.textColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
        $0.keyboardType = .alphabet
        $0.addLeftPadding()
    }

    private let statusLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .blue100
        $0.font = .minsans(size: 12, family: .Medium)
    }

    private let guideButton = UIButton().then {
        $0.backgroundColor = .grayScale500
        $0.setTitleColor(.grayScale300, for: .normal)
        $0.layer.cornerRadius = 16
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
        $0.isEnabled = false
    }

    private let authProvider = MoyaProvider<AuthServices>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setTextField()
        bind()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar(isHidden: false)
        setUpNavigation()
    }
}

extension RegisterEmailVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            titleFirstLabel,
            titleSecondLabel,
            guideLabel,
            emailTextField,
            statusLabel,
            guideButton
        ])
        titleFirstLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(250)
            make.top.equalToSuperview().offset(24)
        }
        titleSecondLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleFirstLabel.snp.bottom).offset(6)
            make.leading.equalTo(titleFirstLabel.snp.leading)
        }
        guideLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleSecondLabel.snp.leading)
            make.top.equalTo(titleSecondLabel.snp.bottom).offset(25)
            make.width.equalTo(50)
        }
        emailTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(guideLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(guideLabel.snp.bottom).offset(9)
            make.width.equalTo(327)
            make.height.equalTo(56)
        }
        statusLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(41)
            make.top.equalTo(emailTextField.snp.bottom).offset(4)
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
        navigationBar.isTranslucent = false
    }

    private func setTextField() {
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(checkAvailability), for: .editingChanged)
    }

    private func bind() {
        guideButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                //self.checkEmailAvailability(self.emailTextField.text ?? "")
                self.sendEmail(self.emailTextField.text ?? "")
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

    // MARK: - 서버 통신 부분(가입된 이메일인지 검사)
    @objc func checkEmailAvailability(_ email: String) {
        let idRequest = checkEmail(email: email)
        authProvider.rx.request(.checkEmail(param: idRequest))
            .asObservable()
            .subscribe(onNext: { [weak self] response in
                let json = JSON(response.data)["message"]
                if json == "이미 존재하는 이메일입니다." {
                    self?.statusLabel.text = "사용할 수 없는 이메일입니다."
                    self?.guideButton.isEnabled = false
                }
                if json == "사용 가능한 이메일입니다." {
                    self?.guideButton.isEnabled = true

                }
            }, onError: { [weak self] _ in
                print("error occured")
            }, onCompleted: {

            }).disposed(by: disposeBag)
    }
    // MARK: - 서버 통신 부분(이메일 인증 보내게)
    @objc func sendEmail(_ email: String) {
        let emailRequest = verifyEmail(email: email)
        authProvider.rx.request(.verifyEmail(param: emailRequest))
            .asObservable()
            .subscribe(onNext: { [weak self] response in
                let status = response.statusCode
                if status == 200 {
                    let viewController = VerifyEmailVC()
                    self?.navigationController?.pushViewController(viewController, animated: true)
                    KeychainHandler.shared.email = email
                }
            }, onError: { [weak self] _ in
                print("error occured")
            }, onCompleted: {

            }).disposed(by: disposeBag)
    }

}

extension RegisterEmailVC: UITextFieldDelegate {
    @objc private func checkAvailability(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.validateEmail() {
            textField.layer.borderColor = UIColor.grayScale400.cgColor
            textField.layer.cornerRadius = 20
            textField.layer.borderWidth = 2.0
            statusLabel.text = ""
            guideButton.isEnabled = true
            guideButton.backgroundColor = .yellow200
            guideButton.setTitleColor(.grayScale900, for: .normal)
        } else {
            textField.layer.borderWidth = 0.0
            statusLabel.text = "유효한 이메일 형식이 아닙니다."
            statusLabel.textColor = .red100
            guideButton.isEnabled = false
            guideButton.backgroundColor = .grayScale500
            guideButton.setTitleColor(.grayScale300, for: .normal)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkEmailAvailability(textField.text ?? "")
        return true
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
}
