//
//  JoinCancelVC.swift
//  Join
//
//  Created by 홍정민 on 2022/04/30.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

protocol CancelDelegate {
    func cancelUpdate(isCanceled: Bool)
}


class JoinCancelVC: BaseViewController {
    
    var delegate: CancelDelegate?
    var isCanceled: Bool = false
    
    let stackView1 = UIStackView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .fillEqually
    }
    
    var popupView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
    }
    
    var sadImage = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "icon_sad")
        $0.contentMode = .scaleAspectFit
    }
    
    var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "참여를 취소하시겠어요?"
        $0.font = UIFont.boldSystemFont(ofSize: 25)
    }
    
    var subTitleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "친구가 슬퍼할거에요."
    }
    
    var resetBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .lightGray
        $0.setTitle("아니요", for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 16
    }
    
    var cancelBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .darkGray
        $0.setTitle("참여취소", for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
    }
    
}



extension JoinCancelVC {
    private func setLayout() {
        self.view.backgroundColor = UIColor(red: 17/255, green: 23/255, blue: 35/255, alpha: 0.6)
        
        view.add(popupView)
        
        stackView1.addArrangedSubview(resetBtn)
        stackView1.addArrangedSubview(cancelBtn)
        
        popupView.adds([
            sadImage,
            titleLabel,
            subTitleLabel,
            stackView1

        ])
        
        popupView.snp.makeConstraints{
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-15)
            $0.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY)
            $0.height.equalTo(350)
        }
        
        sadImage.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalTo(popupView.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(sadImage.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    
        stackView1.snp.makeConstraints{
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(40)
            $0.leading.equalTo(popupView.snp.leading).offset(20)
            $0.trailing.equalTo(popupView.snp.trailing).offset(-20)
            $0.height.equalTo(60)
        }
        

       
    }
    
    private func bind(){
        resetBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.isCanceled = false
                self?.closePopup()
            })
            .disposed(by: disposeBag)
        
        cancelBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.isCanceled = true
                self?.closePopup()
            })
            .disposed(by: disposeBag)
    }
    
    private func closePopup(){
        self.delegate?.cancelUpdate(isCanceled: isCanceled)
        self.dismiss(animated:true)
    }
    
    
}

