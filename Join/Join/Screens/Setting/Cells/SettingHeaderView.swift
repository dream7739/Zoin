//
//  SettingHeaderView.swift
//  Join
//
//  Created by 이윤진 on 2022/06/29.
//

import UIKit

class SettingHeaderView: UICollectionReusableView {
    static let identifier = "SettingHeaderView"

    let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .minsans(size: 16, family: .Bold)
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

extension SettingHeaderView {
    private func render() {
        add(titleLabel) { label in
            label.snp.makeConstraints {
                $0.top.equalToSuperview().offset(24)
                $0.leading.equalToSuperview().offset(24)
                $0.bottom.equalToSuperview().offset(24)
            }
        }
    }
}
