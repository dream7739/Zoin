//
//  OpenedMeetingCVCell.swift
//  Join
//
//  Created by 이윤진 on 2022/06/16.
//

import UIKit

class OpenedMeetingCVCell: UICollectionViewCell {
    static let identifier = "OpenedMeetingCVCell"

    private let profileImageView = UIImageView().then {
        $0.contentMode = .center
        $0.layer.cornerRadius = 30
    }

    private let userNameLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .white
        $0.font = .minsans(size: 14, family: .Medium)
    }

    private let userIdLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .grayScale500
        $0.font = .minsans(size: 12, family: .Medium)
    }

    private let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .white
        $0.text = "번개 타이틀자리입니다."
        $0.font = .minsans(size: 18, family: .Bold)
    }

    // MARK: - 서버 통신 시 dateformatter 필요
    private let dateLabel = UILabel().then {
        $0.textColor = .grayScale400
        $0.font = .minsans(size: 14, family: .Bold)
    }

    private let timeLabel = UILabel().then {
        $0.textColor = .grayScale400
        $0.font = .minsans(size: 14, family: .Medium)
    }

    private let divideLabel = UILabel().then {
        $0.text = "|"
        $0.textColor = .grayScale700
    }

    private let locationLabel = UILabel().then {
        $0.text = "벙개모이는장소"
        $0.font = .minsans(size: 14, family: .Medium)
    }

    private let statusImage = UIImageView().then {
        $0.image = Image.statusImage
    }

    private let memberCountLabel = UILabel().then {
        $0.text = "1/3"
        $0.font = .minsans(size: 12, family: .Medium)
    }
}
