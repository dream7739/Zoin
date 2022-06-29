//
//  SettingCVCell.swift
//  Join
//
//  Created by 이윤진 on 2022/06/29.
//

import UIKit

class SettingCVCell: UICollectionViewCell {
    static let identifier = "SettingCVCell"

    private let backgroundImage = UIView().then {
        $0.backgroundColor = .grayScale800
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 24
    }

    let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .minsans(size: 16, family: .Bold)
    }

    let guideImage = UIImageView().then {
        $0.image = Image.arrowRight
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

extension SettingCVCell {
    private func render() {
        self.contentView.backgroundColor = .grayScale900
        contentView.add(backgroundImage)
        backgroundImage.adds([
            titleLabel,
            guideImage
        ])
        backgroundImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(2)
            make.leading.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-2)
            make.trailing.equalToSuperview().offset(-2)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-24)
        }
        guideImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-24)
        }
    }

}
