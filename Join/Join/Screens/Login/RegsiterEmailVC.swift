//
//  RegsiterEmailVC.swift
//  Join
//
//  Created by 이윤진 on 2022/04/25.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift

class RegsiterEmailVC: BaseViewController {

    private let titleLabel = UILabel().then {
        $0.text = """
            로그인할 때 필요한
            이메일을 입력해주세요.
            """
        $0.textColor = .black
        $0.numberOfLines = 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar(isHidden: false)
        setUpNavigation()
    }

}

extension RegsiterEmailVC {
    private func setLayout() {
        view.adds([
            titleLabel
        ])
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(250)
            make.top.equalToSuperview().offset(14)
        }
    }

    private func setUpNavigation() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isHidden = false
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
    }
}
