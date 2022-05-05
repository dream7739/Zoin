//
//  JoinMemberCell.swift
//  Join
//
//  Created by 홍정민 on 2022/05/05.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import Foundation
import Then

class JoinMemberCell : UITableViewCell {
    
    /**
     프로필 사진
     이름
     아이디
     개최자 여부
     **/
    
    static let identifier = "JoinMemberCell"
    
    var containerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var profileImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "profile")
        $0.layer.cornerRadius = $0.frame.width / 8
        $0.clipsToBounds = true
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
    
    var ownerLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "개최자"
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
        self.containerView.addSubview(profileImg)
        self.containerView.addSubview(nameLabel)
        self.containerView.addSubview(idLabel)
        self.containerView.addSubview(ownerLabel)
        
        self.containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
       }
        
        profileImg.contentMode = .scaleToFill
        
        profileImg.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
        }

        nameLabel.snp.makeConstraints {
           $0.centerY.equalTo(profileImg.snp.centerY)
           $0.leading.equalTo(profileImg.snp.trailing).offset(12)
       }

        idLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel.snp.centerY)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(6)
        }

        ownerLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImg.snp.centerY)
            $0.trailing.equalTo(containerView)
        }

    }

}

