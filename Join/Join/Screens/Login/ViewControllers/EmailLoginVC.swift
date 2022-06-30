//
//  EmailLoginVC.swift
//  Join
//
//  Created by 이윤진 on 2022/06/30.
//

import UIKit

import SnapKit
import SwiftyJSON
import Then
import RxCocoa
import RxSwift
import RxKeyboard
import Moya

class EmailLoginVC: BaseViewController {

    private let idTitleLabel = UILabel().then {
        $0.text = "아이디"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }
    private let idTextField = UITextField().then {
        $0.placeholder = "zoin@letszoin.com"
        $0.setPlaceHolderColor(.grayScale600)
        $0.tintColor = .yellow200
        $0.textColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
        $0.keyboardType = .alphabet
        $0.addLeftPadding()
    }
    private let passwordTitleLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }
    private let passwordTextField = UITextField().then {
        $0.placeholder = "●●●●●●●●"
        $0.isSecureTextEntry = true
        $0.setPlaceHolderColor(.grayScale600)
        $0.tintColor = .yellow200
        $0.textColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
        $0.addLeftPadding()
    }
    private let findButton = UIButton().then {
        $0.setTitleColor(.grayScale100, for: .normal)
        $0.setTitle("아이디/비밀번호 찾기", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Medium)
        $0.setUnderline()
    }

    private let guideButton = UIButton().then {
        $0.backgroundColor = .grayScale500
        $0.setTitleColor(.grayScale300, for: .normal)
        $0.layer.cornerRadius = 16
        $0.setTitle("로그인", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.isEnabled = false
    }

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

extension EmailLoginVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            idTitleLabel,
            idTextField,
            passwordTitleLabel,
            passwordTextField,
            findButton,
            guideButton
        ])
        idTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(45)
        }
        idTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(idTitleLabel.snp.leading)
            make.top.equalTo(idTitleLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(327)
            make.height.equalTo(56)
        }
        passwordTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(idTextField.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(24)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(327)
            make.height.equalTo(56)
        }
        findButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(26)
            make.centerX.equalToSuperview()
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
        title = "로그인"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationBar.isHidden = false
        navigationBar.isTranslucent = false
    }

    private func setTextField() {
        idTextField.delegate = self
        passwordTextField.delegate = self
        idTextField.addTarget(self, action: #selector(checkInput), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(checkInput), for: .editingChanged)
    }

    private func bind() {
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
}

extension EmailLoginVC: UITextFieldDelegate {
    @objc private func checkInput(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > 0 {
            textField.layer.borderColor = UIColor.grayScale400.cgColor
            textField.layer.cornerRadius = 20
            textField.layer.borderWidth = 2.0
        } else {
            textField.layer.borderWidth = 0.0
        }

        if idTextField.text != "" && passwordTextField.text != "" {
            guideButton.isEnabled = true
            guideButton.backgroundColor = .yellow200
            guideButton.setTitleColor(.grayScale900, for: .normal)
        } else {
            guideButton.isEnabled = false
            guideButton.backgroundColor = .grayScale500
            guideButton.setTitleColor(.grayScale300, for: .normal)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
