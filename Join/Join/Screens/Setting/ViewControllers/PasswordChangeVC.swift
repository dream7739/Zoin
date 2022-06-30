//
//  PasswordChangeVC.swift
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

class PasswordChangeVC: BaseViewController {

    private let currentLabel = UILabel().then {
        $0.text = "현재 비밀번호"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }

    private let currentTextField = UITextField().then {
        $0.placeholder = ""
        $0.setPlaceHolderColor(.grayScale600)
        $0.tintColor = .yellow200
        $0.textColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
        $0.keyboardType = .alphabet
        $0.addLeftPadding()
    }

    private let newLabel = UILabel().then {
        $0.text = "신규 비밀번호"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }

    private let newTextField = UITextField().then {
        $0.placeholder = "8자 이상 12자 이하"
        $0.setPlaceHolderColor(.grayScale600)
        $0.tintColor = .yellow200
        $0.textColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
        $0.keyboardType = .alphabet
        $0.addLeftPadding()
    }

    private let validateLabel = UILabel().then {
        $0.text = "신규 비밀번호 확인"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }

    private let validTextField = UITextField().then {
        $0.placeholder = "8자 이상 12자 이하"
        $0.setPlaceHolderColor(.grayScale600)
        $0.tintColor = .yellow200
        $0.textColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
        $0.keyboardType = .alphabet
        $0.addLeftPadding()
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
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar(isHidden: false)
        setUpNavigation()
    }

}

extension PasswordChangeVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            currentLabel,
            currentTextField,
            newLabel,
            newTextField,
            validateLabel,
            validTextField,
            guideButton
        ])
        currentLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(8)
        }
        currentTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(currentLabel.snp.leading)
            make.top.equalTo(currentLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(327)
            make.height.equalTo(56)
        }
        newLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(currentTextField.snp.leading)
            make.top.equalTo(currentTextField.snp.bottom).offset(17)
        }
        newTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(newLabel.snp.leading)
            make.top.equalTo(newLabel.snp.bottom).offset(17)
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(327)
            make.height.equalTo(56)
        }
        validateLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(newTextField.snp.leading)
            make.top.equalTo(newTextField.snp.bottom).offset(17)
        }
        validTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(validateLabel.snp.leading)
            make.top.equalTo(validateLabel.snp.bottom).offset(17)
            make.trailing.equalToSuperview().offset(-24)
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
        title = "비밀번호 변경"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationBar.isHidden = false
        navigationBar.isTranslucent = false
    }

    private func setTextField() {
        currentTextField.delegate = self
        newTextField.delegate = self
        validTextField.delegate = self
        currentTextField.addTarget(self, action: #selector(checkInput), for: .editingChanged)
        newTextField.addTarget(self, action: #selector(checkInput), for: .editingChanged)
        validTextField.addTarget(self, action: #selector(checkInput), for: .editingChanged)
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

extension PasswordChangeVC: UITextFieldDelegate {
    @objc private func checkInput(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > 0 {
            textField.layer.borderColor = UIColor.grayScale400.cgColor
            textField.layer.cornerRadius = 20
            textField.layer.borderWidth = 2.0
        } else {
            textField.layer.borderWidth = 0.0
        }

        if newTextField.text != "" &&  validTextField.text != "" {
            if newTextField.text == validTextField.text {
                guideButton.isEnabled = true
                guideButton.backgroundColor = .yellow200
                guideButton.setTitleColor(.grayScale900, for: .normal)
            } else {
                guideButton.isEnabled = false
                guideButton.backgroundColor = .grayScale500
                guideButton.setTitleColor(.grayScale300, for: .normal)
            }
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

