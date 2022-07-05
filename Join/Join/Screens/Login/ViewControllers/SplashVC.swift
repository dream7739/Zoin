//
//  SplashVC.swift
//  Join
//
//  Created by 이윤진 on 2022/04/25.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift

class SplashVC: BaseViewController {

    private let Button = UIButton().then {
        $0.setTitle("splash/임시버튼", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setLayout()
        bind()
    }

    private func setNavigation() {
        let navigationController: UINavigationController
        let LoginVC: UIViewController = LoginVC()
        navigationController = UINavigationController(rootViewController: LoginVC)
        navigationController.navigationBar.isHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
        
    }

    private func bind() {
        Button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let navigationController: UINavigationController
                let LoginVC: UIViewController = TermVC()
                navigationController = UINavigationController(rootViewController: LoginVC)
                navigationController.navigationBar.isHidden = true
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)
            })
            .disposed(by: disposeBag)

    }

    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.addSubview(Button)
        Button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view).offset(100)
        }
    }
}
