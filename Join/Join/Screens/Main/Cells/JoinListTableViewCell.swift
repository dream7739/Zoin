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

protocol JoinListCellDelegate {
    func selectedJoinList(index: Int)
}

class JoinListTableViewCell : UITableViewCell {
    var delegate:MainCellDelegate!
    
    static let identifier = "joinListCell"
    
    var containerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var profileImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    var nameLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 14, family: .Medium)
        $0.textColor = .grayScale100
    }
    
    var idLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 12, family: .Medium)
        $0.textColor = .grayScale500
    }
    
    var countLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 12, family: .Medium)
        $0.textColor = .grayScale800
    }
    
    var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 18, family: .Bold)
        $0.textColor = .grayScale100
    }
    
    var indicatorView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .grayScale700
    }
    
    var dateLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 14, family: .Medium)
        $0.textColor = .grayScale400
        
    }
    
    var placeLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 14, family: .Medium)
        $0.textColor = .grayScale400
    }
    
    var countView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .green100
    }
    
    var countImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "icon_attend")
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellSetting()
    }
    
    
    
    func cellSetting() {
        self.containerView.backgroundColor = .grayScale900
        
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(profileImg)
        self.containerView.addSubview(nameLabel)
        self.containerView.addSubview(idLabel)
        self.containerView.addSubview(countView)
        self.containerView.addSubview(titleLabel)
        self.containerView.addSubview(dateLabel)
        self.containerView.addSubview(placeLabel)
        self.containerView.addSubview(indicatorView)
        self.countView.adds([countLabel, countImageView])
        
        
        self.containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
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
        
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.trailing.equalTo(countView.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.bottom.equalTo(containerView.snp.bottom).offset(-20)
        }
        
        placeLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.leading.equalTo(indicatorView.snp.trailing).offset(6)
        }
        
        indicatorView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(14)
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(6)
        }
        
        countView.snp.makeConstraints {
            $0.width.equalTo(45)
            $0.height.equalTo(22)
            $0.trailing.equalToSuperview().offset(0)
            $0.top.equalTo(nameLabel.snp.top)
        }
        
        countImageView.snp.makeConstraints {
            $0.width.height.equalTo(10)
            $0.leading.equalToSuperview().offset(6)
            $0.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(countImageView.snp.trailing).offset(4)
            $0.centerY.equalTo(countImageView.snp.centerY)
        }
        
        
    }
}

