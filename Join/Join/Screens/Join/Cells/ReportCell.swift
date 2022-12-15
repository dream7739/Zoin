//
//  ReportCell.swift
//  Join
//
//  Created by 홍정민 on 2022/11/13.
//


import UIKit
import RxSwift

class ReportCell: UITableViewCell {
    var reportCellDelegate: ReportCellDelegate!
    var indexNumber:Int!
    var isClicked : Bool = false {
        didSet {
            if isClicked {
                checkBox.setBackgroundImage(UIImage(named: "radiobtn_select"), for: .normal)
            } else {
                checkBox.setBackgroundImage(UIImage(named: "radiobtn"), for: .normal)
                
            }
        }
    }
    
    static let identifier = "ReportCell"
    let disposeBag = DisposeBag()
    
    var containerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let checkBox = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "radiobtn"), for: .normal)
    }
    
    let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = .minsans(size: 16, family: .Medium)
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

extension ReportCell {
    private func cellSetting() {
        self.contentView.backgroundColor = .grayScale900
        
        
        self.contentView.addSubview(self.containerView)
        
        self.containerView.adds([
            checkBox,
            titleLabel
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
        
        
    }
    
    private func bind() {
        checkBox.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.reportCellDelegate.cellClick(index: self.indexNumber)
            })
            .disposed(by: disposeBag)
        
     
    }
}
