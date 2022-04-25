//
//  RegsiterEmailVC.swift
//  Join
//
//  Created by 이윤진 on 2022/04/25.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift

class RegsiterEmailVC: BaseViewController {

    private let titleLabel = UILabel().then {
        $0.text = """
            로그인할 때 필요한
            이메일을 입력해주세요.✉️
            """
        $0.textColor = .black
        $0.numberOfLines = 2
    }

    private let guideLabel = UILabel().then {
        $0.text = "이메일"
        $0.textColor = .black
    }

    private let emailTextField = UITextField().then {
        $0.placeholder = "  bungae@buangae.com"
        $0.tintColor = .black
        $0.backgroundColor = .lightGray
    }

    private let guideButton = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 16
        $0.setTitle("다음으로", for: .normal)
        // 사용가능한 이메일일때
        // isEnabled, isSelected 설정해놓기
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        emailTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar(isHidden: false)
        setUpNavigation()
    }

}

extension RegsiterEmailVC {
    private func setLayout() {
        view.adds([
            titleLabel,
            guideLabel,
            emailTextField,
            guideButton
        ])
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(250)
            make.top.equalToSuperview().offset(8)
        }
        guideLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.width.equalTo(50)
        }
        emailTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(guideLabel.snp.leading)
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

}

extension RegsiterEmailVC: UITextFieldDelegate {

}
