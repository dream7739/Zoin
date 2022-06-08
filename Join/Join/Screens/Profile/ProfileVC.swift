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

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigation()
    }


}

extension ProfileVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([

        ])
    }

    private func setUpNavigation() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.isHidden = false
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationItem.hidesBackButton = true
        let passButton = UIBarButtonItem(title: "건너뛰기", style: .plain, target: self, action: #selector(moveLast))
        navigationItem.rightBarButtonItem = passButton
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.minsans(size: 18, family: .Bold) ?? UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .normal)
    }

    private func bind() {

    }

    @objc func moveLast() {

    }
}
