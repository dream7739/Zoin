//
//  RegisterProfileVC.swift
//  Join
//
//  Created by 이윤진 on 2022/04/25.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift

class RegisterProfileVC: BaseViewController {

    private let titleFirstLabel = UILabel().then {
        $0.text = "친구가 나를 알아볼 수 있는"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let titleSecondLabel = UILabel().then {
        $0.text = "프로필 사진을 등록해 주세요.📸"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let profileImageView = UIImageView().then {
        $0.image = Image.profileDefault
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }

    private let passButton = UIButton().then {
        $0.setTitleColor(.grayScale100, for: .normal)
        $0.setTitle("다음에 할래요", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Medium)
        $0.setUnderline()
    }
    // TODO: - UI 요소 더 채우기
    // 사진 변경 버튼 hidden -> unhidden
    // 사진 추가 시 changeProfileButton 등장
    // 카메라 접근권한 허용시키기
    private let changeProfileButton = UIButton().then {
        $0.setImage(Image.cameraButton, for: .normal)
        $0.layer.masksToBounds = true
    }

    private let guideButton = UIButton().then {
        $0.backgroundColor = .yellow200
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.layer.cornerRadius = 16
        $0.setTitle("시작하기", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
        // 양식 채워지면 회색이었다가 노란색으로 변경
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
        setLeftBarButton()
    }
}

extension RegisterProfileVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            titleFirstLabel,
            titleSecondLabel,
            profileImageView,
            changeProfileButton,
            passButton,
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
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleSecondLabel.snp.bottom).offset(35)
            make.width.equalTo(140)
            make.height.equalTo(140)
            make.centerX.equalToSuperview()
        }
        changeProfileButton.snp.makeConstraints { (make) in
            make.size.equalTo(36)
            make.trailing.bottom.equalTo(self.profileImageView).inset(-1)
        }
        passButton.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(52)
            make.leading.equalToSuperview().offset(144)
            make.trailing.equalToSuperview().offset(-144)
        }
        // TODO: - 추가될 UI요소 constraint 설정하기
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
        navigationItem.hidesBackButton = true
    }

    private func bind() {
        guideButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let viewController = CompleteProfileVC()
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
