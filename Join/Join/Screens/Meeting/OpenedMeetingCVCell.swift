//
//  OpenedMeetingCVCell.swift
//  Join
//
//  Created by 이윤진 on 2022/06/16.
//

import UIKit

class OpenedMeetingCVCell: UICollectionViewCell {
    static let identifier = "OpenedMeetingCVCell"

    let profileImageView = UIImageView().then {
        $0.contentMode = .center
        $0.layer.cornerRadius = 30
    }

    let userNameLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .white
        $0.font = .minsans(size: 14, family: .Medium)
    }

    let userIdLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .grayScale500
        $0.font = .minsans(size: 12, family: .Medium)
    }

    let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .white
        $0.text = "번개 타이틀자리입니다."
        $0.font = .minsans(size: 18, family: .Bold)
    }

    // MARK: - 서버 통신 시 dateformatter 필요
    // 당일인 경우에는 노란색으로?
    let dateLabel = UILabel().then {
        $0.textColor = .grayScale400
        $0.font = .minsans(size: 14, family: .Bold)
    }

    let timeLabel = UILabel().then {
        $0.textColor = .grayScale400
        $0.font = .minsans(size: 14, family: .Medium)
    }

    let divideLabel = UILabel().then {
        $0.text = "|"
        $0.textColor = .grayScale700
    }

    let locationLabel = UILabel().then {
        $0.text = "벙개모이는장소"
        $0.textColor = .grayScale400
        $0.font = .minsans(size: 14, family: .Medium)
    }

    let statusImage = UIImageView().then {
        $0.image = Image.statusImage
    }

    let memberCountLabel = UILabel().then {
        $0.text = "1/3"
        $0.font = .minsans(size: 12, family: .Medium)
        $0.textColor = .grayScale800
    }

    let divideView = UIView().then {
        $0.backgroundColor = .grayScale800
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension OpenedMeetingCVCell {
    private func render() {
        self.contentView.backgroundColor = .grayScale900
        contentView.adds([
            profileImageView,
            userNameLabel,
            userIdLabel,
            titleLabel,
            dateLabel,
            timeLabel,
            divideLabel,
            locationLabel,
            statusImage,
            divideView
        ])
        statusImage.add(memberCountLabel)
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-16)
            make.size.equalTo(50)
        }
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(18)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        userIdLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(18)
            make.leading.equalTo(userNameLabel.snp.trailing
            ).offset(6)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userNameLabel.snp.bottom).offset(2)
            make.leading.equalTo(userNameLabel.snp.leading)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.top)
            make.leading.equalTo(dateLabel.snp.trailing).offset(5)
        }
        divideLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.top)
            make.leading.equalTo(timeLabel.snp.trailing).offset(5)
        }
        locationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(divideLabel.snp.top)
            make.leading.equalTo(divideLabel.snp.trailing).offset(5)
        }
        statusImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-24)
        }
        memberCountLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-2)
        }
        divideView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    func bind() {
        profileImageView.image = Image.profile
        userNameLabel.text = "이용자이름"
        userIdLabel.text = "이것은 임시입니다."
        titleLabel.text = "번개 타이틀"
        dateLabel.text = "4.5.화"
        timeLabel.text = "오후 12:00"
        locationLabel.text = "여의나루역 4번 출구"
        memberCountLabel.text = "2/3"
    }
}
