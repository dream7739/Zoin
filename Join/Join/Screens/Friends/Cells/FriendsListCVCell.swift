//
//  FriendsListCVCell.swift
//  Join
//
//  Created by 이윤진 on 2022/06/16.
//

import UIKit

import SnapKit
import SwiftyJSON
import Then
import RxCocoa
import RxSwift
import RxKeyboard
import Moya

class FriendsListCVCell: UICollectionViewCell {
    static let identifier = "FriendsListCVCell"

    private let profileImageView = UIImageView().then {
        $0.contentMode = .center
        $0.layer.cornerRadius = 30
    }

    private let userNameLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .white
        $0.font = .minsans(size: 16, family: .Bold)
    }

    private let userIdLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .grayScale500
        $0.font = .minsans(size: 16, family: .Medium)
    }

    let modalButton = UIButton().then {
        // TODO: - 이미지 변경필요
        $0.setImage(Image.icon_more, for: .normal)
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

extension FriendsListCVCell {

    private func render() {
        self.contentView.backgroundColor = .grayScale900
        contentView.adds([
            profileImageView,
            userNameLabel,
            userIdLabel,
            modalButton
        ])
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-16)
            make.size.equalTo(50)
        }
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(18)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        userIdLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(userNameLabel.snp.leading)
            make.bottom.equalTo(profileImageView.snp.bottom)
        }
        modalButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(29)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-29)
            make.size.equalTo(24)
        }
    }

    func bind() {
        profileImageView.image = Image.profile
        userNameLabel.text = "이용자이름"
        userIdLabel.text = "이것은 임시입니다."
    }
}

protocol CollectionViewCellDelegate: AnyObject {
    func actionSheetButtonTapped(_cell: FriendsListCVCell)
}
