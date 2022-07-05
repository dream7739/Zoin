//
//  TermTVC.swift
//  Join
//
//  Created by 홍정민 on 2022/06/30.
//

import UIKit
import RxSwift

class TermTVCell: UITableViewCell {
    var clickDelegate: ClickDelegate!
    var indexNumber:Int!
    var isClicked : Bool = false {
           didSet {
               if isClicked {
                   checkBox.setBackgroundImage(UIImage(named: "checkboxSelected"), for: .normal)
               } else {
                       checkBox.setBackgroundImage(UIImage(named: "checkbox"), for: .normal)
                       
                   }
           }
       }

    static let identifier = "TermTVCell"
    let disposeBag = DisposeBag()
    
    //26 16 16
    var containerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let checkBox = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "checkbox"), for: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = .minsans(size: 16, family: .Medium)
        $0.text = "개인정보 수집 및 이용 동의 (필수)"
    }
    
    private let detailBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "chevron-right"), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 17, left: 0, bottom: 17, right: 0)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellSetting()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(c`oder:) has not been implemented")
    }
}

extension TermTVCell {
    private func cellSetting() {
        self.contentView.backgroundColor = .grayScale900
        
        self.contentView.addSubview(self.containerView)
        
        self.containerView.adds([
            checkBox,
            titleLabel,
            detailBtn,
        ])
        
        self.containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        checkBox.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.top.equalTo(containerView.snp.top).offset(16)
            $0.leading.equalTo(containerView.snp.leading).offset(24)
            $0.bottom.equalTo(containerView.snp.bottom).offset(-16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(checkBox.snp.centerY)
            $0.leading.equalTo(checkBox.snp.trailing).offset(8)
        }
        
        detailBtn.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.trailing.equalTo(containerView.snp.trailing).offset(-24)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        
    }
    
    private func bind() {
        detailBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.clickDelegate.indicatorClick(index: self.indexNumber)

            })
            .disposed(by: disposeBag)
        
        checkBox.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isClicked.toggle()
                self.clickDelegate.cellClick(isClicked : self.isClicked)
            })
            .disposed(by: disposeBag)
    }
}
