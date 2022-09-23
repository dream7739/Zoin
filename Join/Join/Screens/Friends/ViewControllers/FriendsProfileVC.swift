//
//  FriendsProfileVC.swift
//  Join
//
//  Created by 이윤진 on 2022/09/23.
//

import Foundation

import SnapKit
import Then
import RxCocoa
import RxSwift

class FriendsProfilcVC: BaseViewController {
    private let profileBackgroundView = UIView().then {
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 24
    }

    private let profileImageView = UIImageView().then {
        $0.image = Image.profileDefault
        $0.layer.cornerRadius = 12
    }

    private let nicknameLabel = UILabel().then {
        $0.text = "사용자닉네임자리"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let userIdLabel = UILabel().then {
        $0.text = "사용자id자리"
        $0.textColor = .grayScale400
        $0.font = .minsans(size: 16, family: .Medium)
    }

    private let friendsListButton = UIButton().then {
        $0.setTitle("", for: .normal)
        $0.backgroundColor = .grayScale800
    }

    private let friendsCountLabel = UILabel().then {
        $0.text = "0"
        $0.textColor = .yellow200
        $0.font = .minsans(size: 20, family: .Bold)
    }

    private let countSubLabel = UILabel().then {
        $0.text = "내 친구"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 16, family: .Medium)
    }

    private let separateView = UIView().then {
        $0.backgroundColor = .grayScale700
    }

    // 친구 추가 버튼인데 검색버튼 이미지로 잡혀있음
    // TODO : 이미지 수정 필요!
    private let addButton = UIButton().then {
        $0.setImage(Image.searchFriendsButton, for: .normal)
    }

    private let titleLabel = UILabel().then {
        $0.text = "내 번개 보관함"
        $0.textColor = .white
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let boxButton = UIButton().then {
        $0.layer.cornerRadius = 24
        $0.setTitle("", for: .normal)
        $0.backgroundColor = .grayScale900
    }
    private let boxLabel = UILabel().then {
        $0.text = "모집 중"
        $0.textColor = .white
        $0.font = .minsans(size: 16, family: .Bold)
    }
    private let boxImage = UIImageView().then {
        $0.image = Image.ongoing
    }

    private let guideImagefirst = UIImageView().then {
        $0.image = Image.arrow3
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigation()
        setTabBarHidden(isHidden: false)
    }


}

extension FriendsProfilcVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            profileBackgroundView,
            titleLabel,
            boxButton

        ])
        profileBackgroundView.adds([
            profileImageView,
            nicknameLabel,
            userIdLabel,
            friendsListButton,
            separateView,
            addButton
        ])
        friendsListButton.adds([
            friendsCountLabel,
            countSubLabel
        ])
        boxButton.adds([
            boxLabel,
            boxImage,
            guideImagefirst
        ])

        profileBackgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.centerX.equalToSuperview()
            make.width.equalTo(327)
            make.height.equalTo(338)
        }

        profileImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(113)
        }

        nicknameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        userIdLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }

        friendsListButton.snp.makeConstraints { (make) in
            make.top.equalTo(userIdLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(60)
            make.width.equalTo(47)
            make.height.equalTo(54)
        }

        friendsCountLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(2)
            make.centerX.equalToSuperview()
        }

        countSubLabel.snp.makeConstraints { (make) in
            make.top.equalTo(friendsCountLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }

        separateView.snp.makeConstraints { (make) in
            make.top.equalTo(userIdLabel.snp.bottom).offset(36)
            make.width.equalTo(2)
            make.height.equalTo(60)
            make.leading.equalTo(friendsListButton.snp.trailing).offset(60)
        }

        addButton.snp.makeConstraints { (make) in
            make.top.equalTo(friendsListButton.snp.top)
            make.leading.equalTo(separateView.snp.trailing).offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(116)
            make.height.equalTo(43)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileBackgroundView.snp.bottom).offset(24)
            make.leading.equalTo(profileBackgroundView.snp.leading)
        }

        boxButton.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel.snp.leading)
            make.width.equalTo(327)
            make.height.equalTo(50)
        }

        boxLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.leading.equalTo(boxImage.snp.trailing).offset(16)
        }

        boxImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
            make.size.equalTo(24)
        }

        guideImagefirst.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(17)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-17)
            make.size.equalTo(16)
        }

    }

    private func setUpNavigation() {
        title = "친구 프로필"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.isHidden = false
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
    }


    private func bind() {
        // TODO: - 프로필 URL 처리
        friendsCountLabel.text = String(KeychainHandler.shared.friendCount)
        nicknameLabel.text = KeychainHandler.shared.username
        userIdLabel.text = KeychainHandler.shared.serviceId
        if KeychainHandler.shared.profileImgUrl == "" {
            profileImageView.image = Image.profileDefault
        } else {
            profileImageView.image(url: KeychainHandler.shared.profileImgUrl)
        }

        // MARK: - 모집 중인 번개 리스트로 넘어가기
        boxButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let viewController = OpenedMeetingVC()
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)

        friendsListButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //            let viewController = FriendsListVC()
            //            self.navigationController?.pushViewController(viewController, animated: true)
            let viewcontroller = FriendsProfilcVC()
            self.navigationController?.pushViewController(viewcontroller, animated: true)

        })
        .disposed(by: disposeBag)

        // MARK: - 친구 신청 버튼 구현 부분
        //        addButton.rx.tap
        //            .subscribe(onNext: { [weak self] _ in
        //                guard let self = self else { return }
        //                let viewController = FriendsSearchVC()
        //                self.navigationController?.pushViewController(viewController, animated: true)
        //            })
        //            .disposed(by: disposeBag)

    }
}
