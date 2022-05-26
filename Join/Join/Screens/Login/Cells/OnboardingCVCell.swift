//
//  OnboardingCVCell.swift
//  Join
//
//  Created by 이윤진 on 2022/05/12.
//

import UIKit

class OnboardingCVCell: UICollectionViewCell {
    static let identifier = "OnboardingCVCell"

    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let firstDescriptionLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let secondDescriptionLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let imageView = UIImageView().then {
        $0.contentMode = .center
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

extension OnboardingCVCell {

    func bind(_ slide: OnboardingSlide) {
        titleLabel.text = slide.title
        firstDescriptionLabel.text = slide.firstDescription
        secondDescriptionLabel.text = slide.secondDescription
        imageView.image = UIImage(named: slide.image)
    }

    private func render() {
        self.contentView.backgroundColor = .grayScale900
        contentView.adds([
            titleLabel,
            firstDescriptionLabel,
            secondDescriptionLabel,
            imageView
        ])
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(47)
        }
        firstDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        secondDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstDescriptionLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(secondDescriptionLabel.snp.bottom).offset(44)
            make.width.equalTo(307)
            make.height.equalTo(313)
            make.centerX.equalToSuperview()
        }
    }
}
