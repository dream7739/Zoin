//
//  FriendsSearchVC.swift
//  Join
//
//  Created by 이윤진 on 2022/06/16.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift
import RxKeyboard

class FriendsSearchVC: BaseViewController {

    private let searchTextField = UITextField().then {
        $0.placeholder = "아이디를 입력하세요."
        $0.setPlaceHolderColor(.grayScale600)
        $0.tintColor = .yellow200
        $0.textColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
        $0.addLeftPadding()
    }
    private let searchButton = UIButton().then {
        $0.tintColor = .grayScale600
        $0.setImage(Image.searchButton, for: .normal)
    }
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .grayScale900
        collectionView.register(FriendsSearchCVCell.self, forCellWithReuseIdentifier: FriendsSearchCVCell.identififer)
        return collectionView
    }()
    private let emptyView = UIView().then {
        $0.backgroundColor = .grayScale900
    }
    private let emptyStatusLabel = UILabel().then {
        $0.text = "친구를 찾아보세요."
        $0.textColor = .grayScale600
        $0.font = .minsans(size: 16, family: .Medium)
    }
    private let emptyImage = UIImageView().then {
        $0.image = Image.search3D
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
        setTabBarHidden(isHidden: true)
    }

}

extension FriendsSearchVC {

    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            searchTextField,
            collectionView,
            emptyView
        ])
        emptyView.adds([
            emptyStatusLabel,
            emptyImage
        ])
        searchTextField.add(searchButton)
        searchTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(327)
            make.height.equalTo(56)
        }
        searchButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(searchTextField.snp.bottom).offset(6)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        emptyView.snp.makeConstraints { (make) in
            make.top.equalTo(searchTextField.snp.bottom).offset(6)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        emptyImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(70)
            make.centerX.equalToSuperview()
            make.size.equalTo(115)
        }
        emptyStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(emptyImage.snp.bottom).offset(1)
            make.centerX.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func setUpNavigation() {
        title = "친구 검색"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationBar.isHidden = false
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
    }

    private func bind() {
        searchTextField.rx.text
            .do { [weak self] text in
                guard let self = self,
                      let text = text
                else { return }
                if text.count > 0 {
                    self.searchTextField.layer.borderColor = UIColor.grayScale400.cgColor
                    self.searchTextField.layer.cornerRadius = 20
                    self.searchTextField.layer.borderWidth = 2.0
                    self.searchButton.setImage(Image.searchSelectedButton, for: .normal)
                } else {
                    self.searchTextField.layer.borderWidth = 0.0
                    self.searchButton.setImage(Image.searchButton, for: .normal)
                }
            }
            .subscribe(onNext: { [weak self] _ in

            })
            .disposed(by: disposeBag)
    }
}

extension FriendsSearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FriendsSearchCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsSearchCVCell.identififer, for: indexPath) as! FriendsSearchCVCell
        cell.bind()
        // MARK: - 디자인만한것임. 아렉스 적용하면 이 bind는 수정예정
        return cell
    }
}
extension FriendsSearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
}
