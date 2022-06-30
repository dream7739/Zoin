//
//  AccountSettingVC.swift
//  Join
//
//  Created by 이윤진 on 2022/06/29.
//

import UIKit

class AccountSettingVC: BaseViewController {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 24, bottom: 2, right: 24)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .grayScale900
        collectionView.register(AccountSettingCVCell.self, forCellWithReuseIdentifier: AccountSettingCVCell.identifier)
        return collectionView
    }()

    private var accountData: [String] = ["비밀번호 변경", "로그아웃", "탈퇴"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar(isHidden: false)
        setUpNavigation()
        setTabBarHidden(isHidden: true)
    }

}

extension AccountSettingVC {

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
        title = "계정 설정"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationBar.isTranslucent = false
    }

}

extension AccountSettingVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accountData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AccountSettingCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountSettingCVCell.identifier, for: indexPath) as! AccountSettingCVCell
        cell.titleLabel.text = accountData[indexPath.item]
        if indexPath.item == 2 {
            cell.titleLabel.textColor = .grayScale600
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let viewController = PasswordChangeVC()
            self.navigationController?.pushViewController(viewController, animated: true)
        } else if indexPath.item == 2 {
            let viewController = WithdrawVC()
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            // 메뉴별 경로 설정, 화면 이동
        }
    }

}

extension AccountSettingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: view.frame.width - 48, height: 75)
    }

}
