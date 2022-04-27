//
//  JoinListCell.swift
//  Join
//
//  Created by 홍정민 on 2022/04/27.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import Foundation
import Then

class JoinListTableViewCell : UITableViewCell {
    
    /**
     프로필 사진
     이름
     아이디
     참여자수
     제목
     시간
     장소
     **/
    
    static let identifier = "joinListCell"
    
    var containerView = UIView().then {
        $0.backgroundColor = .white
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
        $0.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    var dateLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "오늘 오후 04:00"
    }
    
    var placeLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "여의나루역 2번 출구 앞"
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellSetting()
    }
    

    
    func cellSetting() {
        self.contentView.addSubview(self.containerView)
        self.addSubview(profileImg)
        self.containerView.addSubview(nameLabel)
        self.containerView.addSubview(idLabel)
        self.containerView.addSubview(countLabel)
        self.containerView.addSubview(titleLabel)
        self.containerView.addSubview(dateLabel)
        self.containerView.addSubview(placeLabel)
        
        self.containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
           }
        
        profileImg.contentMode = .scaleToFill
        
        profileImg.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.leading.equalToSuperview()
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImg.snp.top)
           $0.leading.equalTo(profileImg.snp.trailing).offset(10)
       }

        idLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.trailing).offset(10)
            $0.top.equalTo(nameLabel.snp.top)
        }

        countLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top)
            $0.trailing.equalTo(containerView)
            $0.width.equalTo(30)
            $0.bottom.equalTo(idLabel.snp.bottom)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.trailing.equalTo(countLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.bottom.equalTo(containerView.snp.bottom).offset(-20)
        }

        placeLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(2)
        }
        
        
    }
}

