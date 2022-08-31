//
//  RegisterIdVC.swift
//  Join
//
//  Created by 이윤진 on 2022/04/25.
//

import UIKit

import SnapKit
import SwiftyJSON
import Then
import RxCocoa
import RxSwift
import RxKeyboard
import Moya

class RegisterIdVC: BaseViewController {

    private let titleFirstLabel = UILabel().then {
        $0.text = "친구가 나를 찾을때 필요한"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let titleSecondLabel = UILabel().then {
        $0.text = "아이디를 등록해 주세요.🔍"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let guideLabel = UILabel().then {
        $0.text = "아이디"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }

    private let idTextField = UITextField().then {
        $0.placeholder = "영문 8자 이상 12자 이하"
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
        $0.text = "사용할 수 없는 아이디입니다."
        $0.textColor = .red100
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

extension RegisterIdVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            titleFirstLabel,
            titleSecondLabel,
            guideLabel,
            idTextField,
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
        idTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(guideLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(guideLabel.snp.bottom).offset(9)
            make.width.equalTo(327)
            make.height.equalTo(56)
        }
        statusLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(41)
            make.top.equalTo(idTextField.snp.bottom).offset(4)
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

    private func setTextField() {
        idTextField.delegate = self
        idTextField.addTarget(self, action: #selector(checkAvailability), for: .editingChanged)
    }

    private func bind() {

        guideButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.checkIdAvailability(self.idTextField.text ?? "")
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

    // MARK: - 서버 통신 부분
    @objc func checkIdAvailability(_ id: String) {
        let idRequest = checkId(serviceId: id)
        // 자료형 설정하는 부분에서 authprovider 설정필요
        // rx방식이지만, subscribe, onError로 구분해서 에러처리해주고 있다고 보면 됩니다.
        // subscribe -> 서버 연결됐을때 케이스들 구현
        // onError -> 서버연결안될때 팝업같은것들 구현할때 에러처리하는 부분
        authProvider.rx.request(.checkId(param: idRequest))
            .asObservable()
            .subscribe(onNext: { [weak self] response in
                print("test", JSON(response.data))
                // JSON(response.data) -> 서버연결되고 받아오는 body값들
                // 출력해보면, { "message", "status", "timestamp"} 이런식으로 나타남!
                // 나는 200이면서 message값으로 아이디 중복여부를 확인하는거라 다음과같이 조건을 짰음!
                let json = JSON(response.data)["message"]
                if json == "이미 존재하는 아이디입니다." {
                    self?.statusLabel.text = "사용할 수 없는 아이디입니다."
                    self?.guideButton.isEnabled = false
                }
                if json == "사용 가능한 아이디입니다." {
                    self?.guideButton.isEnabled = true
                    KeychainHandler.shared.serviceId = id
                    let viewController = RegisterProfileVC()
                    self?.navigationController?.pushViewController(viewController, animated: true)
                }
            }, onError: { [weak self] _ in
                print("error occured")
            }, onCompleted: {

            }).disposed(by: disposeBag)

    }

}

extension RegisterIdVC: UITextFieldDelegate {
    @objc private func checkAvailability(_ textfield: UITextField) {
        guard let text = textfield.text else { return }
        if text.count > 7 && text.count < 13 {
            textfield.layer.borderColor = UIColor.grayScale400.cgColor
            textfield.layer.cornerRadius = 20
            textfield.layer.borderWidth = 2.0
            statusLabel.text = ""
            guideButton.isEnabled = true
            guideButton.backgroundColor = .yellow200
            guideButton.setTitleColor(.grayScale900, for: .normal)
        } else {
            textfield.layer.borderWidth = 0.0
            statusLabel.text = "영문 8자 이상 12자 이하로 입력해주세요."
            statusLabel.textColor = .red100
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
