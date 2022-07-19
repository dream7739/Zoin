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


// 셀 클릭 이벤트를 정의 - 메인VC에서 처리
protocol MainCellDelegate {
    func selectedJoinBtn(index: Int)
}

class MainCollectionViewCell : UICollectionViewCell {
    
    static let identifier = "mainCell"
    var delegate: MainCellDelegate!
    var index: Int = 0
    
    var backGroundImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }
    
    var profileImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "profile")
        $0.contentMode = .scaleToFill
    }
    
    var timeImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "icon_time")
        $0.contentMode = .center
        
    }
    
    var placeImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "icon_place")
        $0.contentMode = .center
    }
    
    var nameLabel = UILabel().then {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 16, family: .Bold)
    }
    
    var idLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 16, family: .Medium)
        $0.textColor = .grayScale700
        
    }
    
    var countLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 12, family: .Medium)
        $0.textColor = .grayScale800
    }
    
    var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.font = .minsans(size: 20, family: .Bold)
    }
    
    var dateLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 14, family: .Medium)
        $0.textColor = .grayScale900
    }
    
    var placeLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 14, family: .Medium)
        $0.textColor = .grayScale900
    }
    
    var joinBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.setTitle("참여하기", for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 16
        
    }
    
    var countView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .white.withAlphaComponent(0.6)
    }
    
    var countImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "icon_attend")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        layer.cornerRadius = 32.0
        self.cellSetting()
        self.joinBtn.addTarget(self, action: #selector(onTapBtn), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(c`oder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let mainLayoutAttributes = layoutAttributes as! MainCollectionViewLayoutAttributes
        self.layer.anchorPoint = mainLayoutAttributes.anchorPoint
        self.center.y += (mainLayoutAttributes.anchorPoint.y - 0.5) * self.bounds.height
    }
    
    @objc func onTapBtn(){
        self.delegate.selectedJoinBtn(index: index)
    }
    
    
    func cellSetting() {
        
        self.adds([
            backGroundImg,
            profileImg,
            timeImg,
            placeImg,
            nameLabel,
            idLabel,
            titleLabel,
            dateLabel,
            placeLabel,
            joinBtn,
            countView
        ])
        
        countView.adds([countImageView, countLabel])
        
        backGroundImg.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        profileImg.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.leading.equalTo(profileImg.snp.trailing).offset(10)
            $0.trailing.equalTo(countView.snp.leading).offset(5)
        }
        
        idLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom)
        }
        
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImg.snp.leading)
            $0.trailing.equalTo(countView.snp.trailing)
            $0.top.equalTo(profileImg.snp.bottom).offset(24)
        }
        
        timeImg.snp.makeConstraints {
            $0.width.height.equalTo(14)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.bottom.equalTo(placeImg.snp.top).offset(-12)
        }
        
        placeImg.snp.makeConstraints {
            $0.width.height.equalTo(14)
            $0.leading.equalTo(timeImg.snp.leading)
            $0.bottom.equalTo(joinBtn.snp.top).offset(-56)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(timeImg.snp.trailing).offset(8)
            $0.trailing.equalTo(countView.snp.trailing)
            $0.centerY.equalTo(timeImg.snp.centerY)
        }
        
        placeLabel.snp.makeConstraints {
            $0.leading.equalTo(placeImg.snp.trailing).offset(8)
            $0.trailing.equalTo(dateLabel.snp.trailing)
            $0.centerY.equalTo(placeImg.snp.centerY)
        }
        
        joinBtn.snp.makeConstraints {
            $0.leading.equalTo(placeImg.snp.leading)
            $0.trailing.equalTo(placeLabel.snp.trailing)
            $0.bottom.equalToSuperview().offset(-24)
            $0.height.equalTo(48)
        }
        
        countView.snp.makeConstraints {
            $0.width.equalTo(45)
            $0.height.equalTo(22)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(20)
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

