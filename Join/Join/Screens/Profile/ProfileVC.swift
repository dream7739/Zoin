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
import Moya
import SwiftyJSON

class ProfileVC: BaseViewController {
    var notificationType:Int?

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
        $0.backgroundColor = .grayScale900
    }

    private let closedBoxButton = UIButton().then {
        $0.layer.cornerRadius = 24
        $0.setTitle("", for: .normal)
        $0.backgroundColor = .grayScale900
    }

    private let historyBoxButton = UIButton().then {
        $0.setTitle("", for: .normal)
        $0.backgroundColor = .grayScale900
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

    private let historyBoxLabel = UILabel().then {
        $0.text = "참여 내역"
        $0.textColor = .white
        $0.font = .minsans(size: 16, family: .Bold)
    }
    private let boxImage = UIImageView().then {
        $0.image = Image.ongoing
    }

    private let closedBoxImage = UIImageView().then {
        $0.image = Image.ended
    }

    private let historyBoxImage = UIImageView().then {
        $0.image = Image.history
    }

    private let guideImagefirst = UIImageView().then {
        $0.image = Image.arrow3
    }

    private let guideImagesecond = UIImageView().then {
        $0.image = Image.arrow3
    }

    private let guideImagethird = UIImageView().then {
        $0.image = Image.arrow3
    }


    let listProvider = MoyaProvider<ProfileServices>()
    var friendsInfo = [user]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
        countFriends()
        // Do any additional setup after loading the view.
        
        //알림 리스트를 통해 진입한 경우 화면 분기
        if let notificationType = notificationType {
            openRendezvousList()
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigation()
        setTabBarHidden(isHidden: false)
        countFriends()
        makeFriends() //초대하기를 통해 들어온 친구수락
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
            closedBoxButton,
            historyBoxButton
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
            boxImage,
            guideImagefirst
        ])
        closedBoxButton.adds([
            closedBoxLabel,
            closedBoxImage,
            guideImagesecond
        ])
        historyBoxButton.adds([
            historyBoxLabel,
            historyBoxImage,
            guideImagethird
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

        closedBoxButton.snp.makeConstraints { (make) in
            make.top.equalTo(boxButton.snp.bottom).offset(0)
            make.leading.equalTo(titleLabel.snp.leading)
            make.width.equalTo(327)
            make.height.equalTo(50)
        }
        closedBoxLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.leading.equalTo(closedBoxImage.snp.trailing).offset(16)
        }
        closedBoxImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
            make.size.equalTo(24)
        }

        guideImagesecond.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(17)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-17)
            make.size.equalTo(16)
        }

        historyBoxButton.snp.makeConstraints {
            (make) in
            make.top.equalTo(closedBoxButton.snp.bottom).offset(0)
            make.leading.equalTo(titleLabel.snp.leading)
            make.width.equalTo(327)
            make.height.equalTo(50)
        }

        historyBoxImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
            make.size.equalTo(24)
        }

        historyBoxLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.leading.equalTo(closedBoxImage.snp.trailing).offset(16)
        }

        guideImagethird.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(17)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-17)
            make.size.equalTo(16)
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

        // MARK: - 마감되어버린 번개 리스트로 넘어가기
        closedBoxButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                let viewController = ClosedMeetingVC()
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)

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

        editButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let viewController = ProfileChangeVC()
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)

        // MARK: - 번개 참여 내역 리스트를 보러가기
        historyBoxButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                let viewcontroller = EndedMeetingVC()
                self.navigationController?.pushViewController(viewcontroller, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func openRendezvousList(){
        switch notificationType {
        case 2:
            let viewcontroller = EndedMeetingVC()
            self.navigationController?.pushViewController(viewcontroller, animated: true)
            break
        default:
            break
        }
    }


    @objc func moveLast() {
        let viewController = SettingVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @objc func countFriends() {
        listProvider.rx.request(.getFriendsList)
            .asObservable()
            .subscribe(onNext: {[weak self] response in
                let msg = JSON(response.data)["message"]

                print("findfriends", response)
                print("findfriends", msg)
                if response.statusCode == 200 {
                    let arr = JSON(response.data)["data"]
                    self?.friendsInfo = []
                    for item in arr.arrayValue {
                        let id = item["id"].intValue
                        let serviceId = item["serviceId"].stringValue
                        let userName = item["userName"].stringValue
                        let email = item["email"].stringValue
                        let profileImgUrl = item["profileImgUrl"].stringValue
                        let createdAt = item["createdAt"].stringValue
                        let updatedAt = item["updatedAt"].stringValue
                        self?.friendsInfo.append(user(id: id, serviceId: serviceId, userName: userName, email: email, profileImgUrl: profileImgUrl, createdAt: createdAt, updatedAt: updatedAt))
                        KeychainHandler.shared.friendCount = self?.friendsInfo.count ?? 0
                        self?.friendsCountLabel.text = String(KeychainHandler.shared.friendCount)
                    }

                }
            }, onError: {[weak self] _ in

            }).disposed(by: disposeBag)
    }
    
    @objc func makeFriends() {
        let scene = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        
        if !scene.isInvited {
            return
        }else{
            scene.isInvited = false
        }
        
        guard let userId = scene.inviteUserId else { return }
        
        listProvider.rx.request(.invitation(param: friendId(invitingFriendId: userId)))
                .asObservable()
                .subscribe(onNext: { [weak self] response in
                    guard let self = self else { return }
                    let status = JSON(response.data)["status"]
                    let message = JSON(response.data)["message"]
                    print("make status \(status), message: \(message)")
                    if status == 200 {
                        print("success")
                        self.showMakeFriendAlert()
                    }
                    
                }, onError: { [weak self] _ in
                    print("error occured")
                }, onCompleted: {
                }).disposed(by: disposeBag)
        }
    
    func showMakeFriendAlert(){
        let alert = UIAlertController(title: "친구 요청을 수락했어요", message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default, handler:  nil)
        
        alert.addAction(confirm)
        
        alert.view.tintColor = .grayScale900
        self.present(alert, animated: true)
    }
      
}
