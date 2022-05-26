//
//  CautionVC.swift
//  Join
//
//  Created by 이윤진 on 2022/05/12.
//

import UIKit

class CautionVC: BaseViewController {

    private let titleLabel = UILabel().then {
        $0.text = "쪼인 3배 더 즐기는 법?"
        $0.textColor = .yellow200
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let firstSubLabel = UILabel().then {
        $0.text = "알림 허용이 필요해요😉"
        $0.textColor = .white
        $0.font = .minsans(size: 18, family: .Medium)
    }

    private let secondSubLabel = UILabel().then {
        $0.text = "추후 언제든지 알림을 해제할 수 있어요!"
        $0.textColor = .white
        $0.font = .minsans(size: 18, family: .Medium)
    }

    private let bellImageView = UIImageView().then {
        $0.image = UIImage(named: "bell 1")
    }

    private let layerView = UIView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 24
        $0.backgroundColor = .white
    }

    private let firstSituationLabel = UILabel().then {
        $0.text = "⚡️ 친구신청을 받거나 수락했을 때"
        $0.textColor = .black
        $0.font = .minsans(size: 16, family: .Medium)
    }

    private let secondSituationLabel = UILabel().then {
        $0.text = "⚡️ 친구가 번개를 쳤을 때"
        $0.textColor = .black
        $0.font = .minsans(size: 16, family: .Medium)
    }

    private let thirdSituationLabel = UILabel().then {
        $0.text = "⚡️ 내 번개에 참여하는 친구가 나타났을 때"
        $0.textColor = .black
        $0.font = .minsans(size: 16, family: .Medium)
    }

    private let fourthSituationLabel = UILabel().then {
        $0.text = "⚡️ 번개가 마감되었을 때"
        $0.textColor = .black
        $0.font = .minsans(size: 16, family: .Medium)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigation()
        setLeftBarButton() // backbutton 없애기용
    }

}

extension CautionVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            titleLabel,
            firstSubLabel,
            secondSubLabel,
            bellImageView,
            layerView
        ])
        layerView.adds([
            firstSituationLabel,
            secondSituationLabel,
            thirdSituationLabel,
            fourthSituationLabel
        ])
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(41)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(225)
        }
        firstSubLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
            make.width.equalTo(284)
        }
        secondSubLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstSubLabel.snp.bottom).offset(5)
            make.leading.equalTo(firstSubLabel.snp.leading)
            make.width.equalTo(284)
        }
        bellImageView.snp.makeConstraints { (make) in
            make.top.equalTo(secondSubLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(153)
            make.height.equalTo(155)
        }
        layerView.snp.makeConstraints() { (make) in
            make.top.equalTo(bellImageView.snp.bottom).offset(55)
            make.centerX.equalToSuperview()
            make.width.equalTo(327)
            make.height.equalTo(164)
        }
        firstSituationLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        secondSituationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstSituationLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalTo(firstSituationLabel.snp.leading)
        }
        thirdSituationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(secondSituationLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalTo(secondSituationLabel.snp.leading)
        }
        fourthSituationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(thirdSituationLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalTo(thirdSituationLabel.snp.leading)
            make.bottom.equalToSuperview().offset(-24)
        }
    }

    private func setUpNavigation() {
        title = "알림 설정"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationBar.isHidden = false
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationItem.hidesBackButton = true
    }
    private func bind() {
        presentViewController()
    }

    private func presentViewController() {
        let time = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: time) {
            let viewController = TabBarController()
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
}
