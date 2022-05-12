//
//  CautionVC.swift
//  Join
//
//  Created by 이윤진 on 2022/05/12.
//

import UIKit

class CautionVC: BaseViewController {

    private let titleFirstLabel = UILabel().then {
        $0.text = "알림허용화면"
        $0.textColor = .black
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
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
        }
    }
}
