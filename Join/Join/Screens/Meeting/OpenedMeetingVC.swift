//
//  OpenedMeetingVC.swift
//  Join
//
//  Created by 이윤진 on 2022/06/16.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift

class OpenedMeetingVC: BaseViewController {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .grayScale900
        collectionView.register(OpenedMeetingCVCell.self, forCellWithReuseIdentifier: OpenedMeetingCVCell.identifier)
        return collectionView
    }()
}

extension OpenedMeetingVC {
    private func setLayout() {


    }

    private func setUpNavigation() {
        title = "모집 중"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationBar.isTranslucent = false

    }
}
