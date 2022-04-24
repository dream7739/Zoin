//
//  MainCollectionViewCell.swift
//  Join
//
//  Created by 홍정민 on 2022/04/24.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import Foundation
import Then

class MainCollectionViewCell : UICollectionViewCell {
    
    /**
     프로필 사진
     이름
     아이디
     참여자수
     제목
     시간
     장소
     참여버튼
     **/
    
    static let identifier = "mainCell"
    
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        layer.cornerRadius = 32.0

        self.cellSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(c`oder:) has not been implemented")
    }
    
    func cellSetting() {

        self.backgroundColor = .lightGray
        
        self.addSubview(profileImg)
        self.addSubview(nameLabel)
        self.addSubview(idLabel)
        self.addSubview(countLabel)
        self.addSubview(titleLabel)
        self.addSubview(dateLabel)
        self.addSubview(placeLabel)
        self.addSubview(joinBtn)
        
        profileImg.contentMode = .scaleToFill
        
        profileImg.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.leading.equalTo(profileImg.snp.trailing).offset(10)
            $0.trailing.equalTo(countLabel.snp.leading).offset(5)
        }
        
        idLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom)
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(profileImg.snp.top)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImg.snp.leading)
            $0.trailing.equalTo(countLabel.snp.trailing)
            $0.top.equalTo(profileImg.snp.bottom).offset(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImg.snp.leading)
            $0.trailing.equalTo(countLabel.snp.trailing)
            $0.top.equalTo(titleLabel.snp.bottom).offset(52)
        }
        
        placeLabel.snp.makeConstraints {
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.trailing.equalTo(dateLabel.snp.trailing)
            $0.top.equalTo(dateLabel.snp.bottom)
        }
        
        joinBtn.snp.makeConstraints {
            $0.leading.equalTo(placeLabel.snp.leading)
            $0.trailing.equalTo(placeLabel.snp.trailing)
            $0.bottom.equalToSuperview().offset(-24)
            $0.height.equalTo(48)
        }
        
    }
}

