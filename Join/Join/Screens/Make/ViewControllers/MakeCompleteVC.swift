//
//  MakeCompleteVC.swift
//  Join
//
//  Created by 홍정민 on 2022/05/12.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import RxKeyboard


class MakeCompleteVC: BaseViewController {
    var listFlag = false
    var detailIndex = 0 //번개 고유 번호 전달
    var element:MainElements!
    
    private let mentLabel = UILabel().then {
        $0.text = "추카추카!\n내 소중한 번개가 열렸어요"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let subMentLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = "친구들이 모이길 기다려봅시다."
        $0.textColor = .yellow100
        $0.font = .minsans(size: 16, family: .Medium)
    }
    
    private let completeImageView = UIImageView().then {
        $0.image = UIImage(named: "make_complete")
    }
    
    private let btnStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 11
        $0.axis = .horizontal
    }
    
    private let anotherJoinBtn = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.layer.cornerRadius = 16
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.setTitle("다른 번개 보기", for: .normal)
        $0.layer.cornerRadius = 20
    }
    
    private let confirmBtn = UIButton().then {
        $0.backgroundColor = .yellow200
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.layer.cornerRadius = 16
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.setTitle("확인하기", for: .normal)
        $0.layer.cornerRadius = 20
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
    }
    
    
}

extension MakeCompleteVC {
    private func setLayout() {
        setNavigationBar(isHidden: true)
        
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        
        view.adds([mentLabel
                   ,subMentLabel
                   ,completeImageView
                   ,btnStackView])
        
        btnStackView.addArrangedSubview(anotherJoinBtn)
        btnStackView.addArrangedSubview(confirmBtn)
        
        mentLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(53)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(72)
        }
        
        
        subMentLabel.snp.makeConstraints {
            $0.centerX.equalTo(mentLabel.snp.centerX)
            $0.top.equalTo(mentLabel.snp.bottom).offset(8)
        }
        
        
        completeImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subMentLabel.snp.bottom).offset(80)
            $0.width.height.equalTo(200)
        }
        
        
        btnStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-48)
            $0.height.equalTo(56)
        }
        
        anotherJoinBtn.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        confirmBtn.snp.makeConstraints {
            $0.height.equalTo(anotherJoinBtn.snp.height)
        }
        
    }
    
    private func bind(){
        anotherJoinBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let tabBar = self.tabBarController
                tabBar?.selectedIndex = 0
                self.listFlag = true
                self.navigationController?.popToRootViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name("listFlag"), object: self.listFlag)
            })
            .disposed(by: disposeBag)
        
        confirmBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let tabBar = self.tabBarController
                tabBar?.selectedIndex = 0
                self.navigationController?.popToRootViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name("detailFlag"), object: self.element)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    
}
