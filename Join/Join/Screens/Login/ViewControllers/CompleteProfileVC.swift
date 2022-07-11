//
//  CompleteProfileVC.swift
//  Join
//
//  Created by 이윤진 on 2022/05/04.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift

class CompleteProfileVC: BaseViewController {


    private let titleLabel = UILabel().then {
        $0.text = "프로필이 완성되었어요!🎉"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let profileImageView = UIImageView().then {
        $0.image = Image.profileDefault
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }

    private let backgroundImage = UIImageView().then {
        $0.image = Image.profileCard
        $0.contentMode = .scaleAspectFill
    }

    private let cardImageView = UIView().then {
        $0.backgroundColor = .yellow100
        $0.layer.cornerRadius = 32

    }

    private let nicknameLabel = UILabel().then {
        $0.text = "사용자닉네임자리"
        $0.textColor = .grayScale900
        $0.font = .minsans(size: 20, family: .Bold)
    }

    private let userIdLabel = UILabel().then {
        $0.text = "사용자id자리"
        $0.textColor = .grayScale900
        $0.font = .minsans(size: 20, family: .Bold)
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


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cardImageView.setGradient(color1: .blue100, color2: .grayScale100)
    }
}

extension CompleteProfileVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            titleLabel,
            backgroundImage
        ])
        backgroundImage.adds([
            cardImageView
        ])
        cardImageView.adds([
            profileImageView,
            nicknameLabel,
            userIdLabel
        ])
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(44)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(270)
        }
        backgroundImage.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
            make.height.equalTo(500)
        }
        cardImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
            make.width.equalTo(259)
            make.height.equalTo(330)
        }
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.width.equalTo(140)
            make.height.equalTo(140)
            make.centerX.equalToSuperview()
        }
        nicknameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        userIdLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
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
        presentViewController()
    }

    private func presentViewController() {
        let time = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: time) {
            let viewController = OnboardingVC()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
