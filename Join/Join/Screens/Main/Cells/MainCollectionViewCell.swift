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
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 20)
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

        self.backgroundColor = UIColor(displayP3Red: 229/255, green: 231/255, blue: 236/255, alpha: 1)
        
        self.adds([
            profileImg,
            timeImg,
            placeImg,
            nameLabel,
            idLabel,
            countLabel,
            titleLabel,
            dateLabel,
            placeLabel,
            joinBtn
        ])
        
        

        
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
        
        timeImg.snp.makeConstraints {
            $0.width.height.equalTo(14)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.bottom.equalTo(placeImg.snp.top).offset(-4)
        }
        
        placeImg.snp.makeConstraints {
            $0.width.height.equalTo(14)
            $0.leading.equalTo(timeImg.snp.leading)
            $0.bottom.equalTo(joinBtn.snp.top).offset(-56)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(timeImg.snp.trailing).offset(8)
            $0.trailing.equalTo(countLabel.snp.trailing)
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
        
    }
}

