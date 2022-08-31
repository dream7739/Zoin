//
//  FriendsSearchCVCell.swift
//  Join
//
//  Created by 이윤진 on 2022/06/16.
//

import UIKit

class FriendsSearchCVCell:
    UICollectionViewCell {
    static let identififer = "FriendsSearchCVCell"

    let profileImageView = UIImageView().then {
        $0.contentMode = .center
        $0.layer.cornerRadius = 30
    }

    let userNameLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .white
        $0.font = .minsans(size: 16, family: .Bold)
    }

    let userIdLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .grayScale500
        $0.font = .minsans(size: 16, family: .Medium)
    }

    let addButton = UIButton().then {
        $0.setImage(Image.addFriendsBtn, for: .normal)
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

extension FriendsSearchCVCell {
    private func render() {
        self.contentView.backgroundColor = .grayScale900
        contentView.adds([
            profileImageView,
            userNameLabel,
            userIdLabel,
            addButton
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
        addButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-24)

        }
    }

    func bind() {
        profileImageView.image = Image.profile
        userNameLabel.text = "이용자이름"
        userIdLabel.text = "이것은 임시입니다."
    }
}
