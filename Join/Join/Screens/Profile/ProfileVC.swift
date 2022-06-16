//
//  ProfileVC.swift
//  Join
//
//  Created by 이윤진 on 2022/04/20.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift

class ProfileVC: BaseViewController {


    private let profileBackgroundView = UIView().then {
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 24
    }

    private let editButton = UIButton().then {
        $0.setImage(Image.edit, for: .normal)
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
        $0.text = "123"
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

    private let searchButton = UIButton().then {
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
        $0.backgroundColor = .grayScale800
    }

    private let closedBoxButton = UIButton().then {
        $0.layer.cornerRadius = 24
        $0.setTitle("", for: .normal)
        $0.backgroundColor = .grayScale800
    }

    private let boxLabel = UILabel().then {
        $0.text = "모집 중"
        $0.textColor = .white
        $0.font = .minsans(size: 16, family: .Bold)
    }

    private let closedBoxLabel = UILabel().then {
        $0.text = "마감"
        $0.textColor = .white
        $0.font = .minsans(size: 16, family: .Bold)
    }

    private let boxImage = UIImageView().then {
        $0.image = Image.pinkArchive
    }

    private let closedBoxImage = UIImageView().then {
        $0.image = Image.greenArchive
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

extension ProfileVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            profileBackgroundView,
            titleLabel,
            boxButton,
            closedBoxButton
        ])
        profileBackgroundView.adds([
            profileImageView,
            editButton,
            nicknameLabel,
            userIdLabel,
            friendsListButton,
            //friendsCountLabel,
            //countSubLabel,
            separateView,
            searchButton
        ])
        friendsListButton.adds([
            friendsCountLabel,
            countSubLabel
        ])
        boxButton.adds([
            boxLabel,
            boxImage
        ])
        closedBoxButton.adds([
            closedBoxLabel,
            closedBoxImage
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

        editButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(24)
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

        searchButton.snp.makeConstraints { (make) in
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
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.equalTo(titleLabel.snp.leading)
            make.size.equalTo(156)
        }

        boxLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }

        boxImage.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.size.equalTo(64)
        }

        closedBoxLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        closedBoxImage.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.size.equalTo(64)
        }
        closedBoxButton.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.equalTo(boxButton.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-24)
            make.size.equalTo(156)
        }
    }

    private func setUpNavigation() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.isHidden = false
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        // navigationItem.hidesBackButton = true
        let settingImage = Image.settingButton?.withAlignmentRectInsets(UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 6.0))
            .withTintColor(.white)
            .withRenderingMode(.alwaysOriginal)
        let passButton = UIBarButtonItem(image: settingImage, style: .plain, target: self, action: #selector(moveLast))
        navigationItem.rightBarButtonItem = passButton
        /* navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.minsans(size: 18, family: .Bold) ?? UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .normal) */
    }

    private func bind() {
        friendsListButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let viewController = FriendsListVC()
            self.navigationController?.pushViewController(viewController, animated: true)

        })
        .disposed(by: disposeBag)

        searchButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let viewController = FriendsSearchVC()
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }

    @objc func moveLast() {

    }
}
