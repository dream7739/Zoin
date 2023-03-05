//
//  AlarmListTableViewCell.swift
//  Join
//
//  Created by 홍정민 on 2023/01/15.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import Foundation
import Then

protocol AlarmListCellDelegate {
    func selectAcceptBtn(friendUserId: Int)    //수락하기 버튼 클릭
}

class AlarmListTableViewCell : UITableViewCell {
    var delegate:AlarmListCellDelegate!
    var rendezvousId: Int?
    var friendUserId: Int?
    
    static let identifier = "alarmListTableViewCell"
    
    var containerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var alarmImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    var alarmMessageLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 14, family: .Medium)
        $0.textColor = .grayScale100
        $0.numberOfLines = 0
    }
    
    var acceptBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.setTitle("수락하기", for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.titleLabel?.font = .minsans(size: 14, family: .Bold)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 16
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellSetting()
        self.acceptBtn.addTarget(self, action: #selector(onTapBtn), for: .touchUpInside)
    }
    
    //수락하기 버튼 이벤트
    @objc func onTapBtn(){
        self.delegate.selectAcceptBtn(friendUserId: friendUserId!)
    }
    
    func cellSetting() {
        self.containerView.backgroundColor = .grayScale900
        
        self.contentView.addSubview(containerView)
        self.containerView.addSubview(alarmImageView)
        self.containerView.addSubview(alarmMessageLabel)
        self.containerView.addSubview(acceptBtn)
        
        self.containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alarmImageView.snp.makeConstraints {
            $0.width.height.equalTo(36)
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(24)
        }
        
        alarmMessageLabel.snp.makeConstraints {
            $0.leading.equalTo(alarmImageView.snp.trailing).offset(12)
            $0.top.equalTo(alarmImageView.snp.top)
        }
        
        acceptBtn.snp.makeConstraints {
            $0.leading.equalTo(alarmMessageLabel.snp.leading)
            $0.top.equalTo(alarmMessageLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-16)
            $0.height.equalTo(32)
            $0.width.equalTo(75)
        }
        
        
    }
}

