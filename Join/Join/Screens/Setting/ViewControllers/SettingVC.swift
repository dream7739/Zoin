//
//  SettingVC.swift
//  Join
//
//  Created by 이윤진 on 2022/06/29.
//

import UIKit

class SettingVC: BaseViewController {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 24, bottom: 2, right: 24)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .grayScale900
        collectionView.register(SettingCVCell.self,forCellWithReuseIdentifier: SettingCVCell.identifier)
        collectionView.register(SettingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SettingHeaderView.identifier)
        return collectionView
    }()

    private var settingData: [String] = ["알림설정", "계정설정"]
    private var infoData: [String] = ["버전 정보", "고객센터", "만든 이들", "오픈소스 라이센스", "개인정보 이용 정책"]

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

extension SettingVC {
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
}

extension SettingVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if section == 0 {
            return settingData.count
        } else {
            return infoData.count
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell: SettingCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCVCell.identifier, for: indexPath) as! SettingCVCell
            cell.titleLabel.text = settingData[indexPath.item]
            return cell
        } else {
            let cell: SettingCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCVCell.identifier, for: indexPath) as! SettingCVCell
            cell.titleLabel.text = infoData[indexPath.item]
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.item == 1 {
                let viewController = AccountSettingVC()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        } else {
            // 메뉴별 경로 설정, 화면 이동
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SettingHeaderView.identifier, for: indexPath) as! SettingHeaderView

            if indexPath.section == 0 {
                headerView.titleLabel.text = "앱 설정"
            } else {
                headerView.titleLabel.text = "앱 정보"
            }
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }


}

extension SettingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: view.frame.width - 48, height: 75)
    }

    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: view.frame.width - 48, height: 55)
    }
}
