//
//  FriendsListVC.swift
//  Join
//
//  Created by 이윤진 on 2022/06/14.
//

import UIKit

import SwiftyJSON
import Moya

class FriendsListVC: BaseViewController {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .grayScale900
        collectionView.register(FriendsListCVCell.self,forCellWithReuseIdentifier: FriendsListCVCell.identifier)
        return collectionView
    }()

    let listProvider = MoyaProvider<ProfileServices>()
    var friendsInfo = [user]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        getFriendsList()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar(isHidden: false)
        setUpNavigation()
        setTabBarHidden(isHidden: true)
    }

}

extension FriendsListVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            collectionView
        ])
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func setUpNavigation() {
        title = "내 친구"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationBar.isTranslucent = false

    }

    @objc func showActionSheet() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제", style: .default)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        optionMenu.view.tintColor = .grayScale900
        self.present(optionMenu, animated: true, completion: nil)
    }

    @objc private func getFriendsList() {
        //let token = tokenRequest(Authorization: KeychainHandler.shared.accessToken)
        listProvider.rx.request(.getFriendsList)
            .asObservable()
            .subscribe(onNext: {[weak self] response in
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
                    }
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                }
            }, onError: {[weak self] _ in

            }).disposed(by: disposeBag)
    }
}

extension FriendsListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FriendsListCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsListCVCell.identifier, for: indexPath) as! FriendsListCVCell
        //cell.bind()
        if friendsInfo[indexPath.item].profileImgUrl == "" {
            cell.profileImageView.image = Image.defaultProfile
        } else {
            cell.profileImageView.image(url: friendsInfo[indexPath.item].profileImgUrl)
        }
        cell.userIdLabel.text = friendsInfo[indexPath.item].serviceId
        cell.userNameLabel.text = friendsInfo[indexPath.item].userName
        cell.modalButton.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendsInfo.count
    }
}

extension FriendsListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
}

extension FriendsListVC: CollectionViewCellDelegate {
    // MARK: - cell 내부의 버튼 눌렀을때의 액션처리
    func actionSheetButtonTapped(_cell: FriendsListCVCell) {
        // cell 삭제 시 적용되는 액션코드
        //        tagTableView.beginUpdates()
        //        if let indexPath = tagTableView.indexPath(for: cell) {
        //            tagTableView.deleteRows(at: [indexPath], with: .fade)
        //        }
        //        tagTableView.endUpdates()
    }
}
