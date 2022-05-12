//
//  CautionVC.swift
//  Join
//
//  Created by 이윤진 on 2022/05/12.
//

import UIKit

class CautionVC: BaseViewController {

    private let titleFirstLabel = UILabel().then {
        $0.text = "알림허용화면/임시"
        $0.textColor = .black
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

extension CautionVC {
    private func setLayout() {
        view.adds([
            titleFirstLabel
        ])
        titleFirstLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view).offset(100)
        }
    }

    private func bind() {
        presentViewController()
    }

    private func presentViewController() {
        let time = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: time) {
            let viewController = TabBarController()
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: false)
        }
    }
}
