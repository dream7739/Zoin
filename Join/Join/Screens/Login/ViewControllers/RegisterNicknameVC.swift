//
//  RegisterNicknameVC.swift
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

class RegisterNicknameVC: BaseViewController {
    
    private let titleFirstLabel = UILabel().then {
        $0.text = "쪼인에 오신걸 환영해요⚡️"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let titleSecondLabel = UILabel().then {
        $0.text = "먼저 닉네임을 알려주세요."
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let guideLabel = UILabel().then {
        $0.text = "닉네임"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }
    private let nicknameTextField = UITextField().then {
        $0.placeholder = "한글 2자 이상 6자 이하"
        $0.setPlaceHolderColor(.grayScale600)
        $0.tintColor = .yellow200
        $0.textColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
        $0.addLeftPadding()
    }

    private let statusLabel = UILabel().then {
        $0.text = "한글 2자 이상 6자 이하"
        $0.textColor = .red100
        $0.font = .minsans(size: 12, family: .Medium)
        // 한글 2자 이상 6자 이하로 입력해주세요.
    }

    private let guideButton = UIButton().then {
        $0.backgroundColor = .yellow200
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.layer.cornerRadius = 16
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
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

extension RegisterNicknameVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            titleFirstLabel,
            titleSecondLabel,
            guideLabel,
            nicknameTextField,
            statusLabel,
            guideButton
        ])
        titleFirstLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(24)
        }
        titleSecondLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleFirstLabel.snp.bottom).offset(6)
            make.leading.equalTo(titleFirstLabel.snp.leading)
        }
        guideLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleSecondLabel.snp.leading)
            make.top.equalTo(titleSecondLabel.snp.bottom).offset(25)
            make.width.equalTo(100)
        }
        nicknameTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(guideLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(guideLabel.snp.bottom).offset(9)
            make.width.equalTo(327)
            make.height.equalTo(56)
        }
        statusLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(41)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(4)
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
        // TODO: - 텍스트필드 입력 시 한글 6글자 제한걸기
        nicknameTextField.rx.text
            .do{ [weak self] text in
                guard let self = self,
                      let text = text
                else { return }
                if text.count > 0  {
                    self.nicknameTextField.layer.borderColor = UIColor.grayScale400.cgColor
                    self.nicknameTextField.layer.cornerRadius = 20
                    self.nicknameTextField.layer.borderWidth = 2.0
                } else {
                    self.nicknameTextField.layer.borderWidth = 0.0
                }
            }
            .subscribe(onNext:  { [weak self] _ in

            })
            .disposed(by: disposeBag)

        guideButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let viewController = RegisterIdVC()
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
