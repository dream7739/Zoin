//
//  OnboardingSubVC.swift
//  Join
//
//  Created by 이윤진 on 2022/05/12.
//

import UIKit

class OnboardingSubVC: UIViewController {


    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private let titleLabel = UILabel().then {
        $0.textColor = .black
    }
    private let subTitleLabel = UILabel().then {
        $0.textColor = .black
    }
    private let subTitleSecondLabel = UILabel().then {
        $0.textColor = .black
    }

    init(imageName: String, titleText: String, subTitleText: String, subTitleSecondText: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: imageName)
        titleLabel.text = titleText
        subTitleLabel.text = subTitleText
        subTitleSecondLabel.text = subTitleSecondText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        // Do any additional setup after loading the view.
    }
}

extension OnboardingSubVC {

    private func setLayout() {
        view.adds([
            imageView,
            titleLabel,
            subTitleLabel,
            subTitleSecondLabel
        ])
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.width.equalTo(280)
            make.leading.equalToSuperview().offset(45)
            make.centerX.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.width.equalTo(160)
            make.centerX.equalToSuperview()
        }
        subTitleSecondLabel.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            make.width.equalTo(160)
            make.centerX.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleSecondLabel.snp.bottom).offset(45)
            make.width.equalTo(281)
            make.height.equalTo(281)
            make.centerX.equalToSuperview()
        }
    }
}
