//
//  JoinVC.swift
//  Join
//
//  Created by 이윤진 on 2022/04/20.
//

import UIKit

class JoinVC: BaseViewController {
    var popupView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    var profileImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "profile")
    }
    
    var nameLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "장혜진"
        $0.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    var idLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "@b2_cka_"
    }
    
    var countLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "2/3"
    }
    
    var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "인생샷 찍으러 가자!"
        $0.font = UIFont.boldSystemFont(ofSize: 30)
    }
    
    var dateLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "오늘 오후 04:00"
    }
    
    var placeLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "여의나루역 2번 출구 앞"
    }
    
    var joinBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .darkGray
        $0.setTitle("참여하기", for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    

}

extension JoinVC {
    private func setLayout() {
        self.view.backgroundColor = UIColor(red: 17/255, green: 23/255, blue: 35/255, alpha: 0.6)
            
        view.add(popupView)
        
        popupView.adds([
            profileImg,
            nameLabel,
            idLabel,
            countLabel,
            titleLabel,
            dateLabel,
            placeLabel,
            joinBtn
        ])
        
        popupView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(681)
        }
        
        profileImg.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(15)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImg)
            $0.leading.equalTo(profileImg.snp.trailing).offset(10)
        }
        
        idLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImg.snp.leading)
            $0.top.equalTo(profileImg.snp.bottom).offset(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImg.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
        
        placeLabel.snp.makeConstraints {
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.top.equalTo(dateLabel.snp.bottom).offset(5)
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(placeLabel.snp.leading)
            $0.top.equalTo(placeLabel.snp.bottom).offset(5)
        }
        
        joinBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-30)
            $0.height.equalTo(48)
            $0.width.equalTo(327)
            $0.centerX.equalToSuperview()
        }
    }
    
    
}

