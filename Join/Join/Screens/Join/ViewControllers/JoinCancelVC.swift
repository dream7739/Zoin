//
//  JoinCancelVC.swift
//  Join
//
//  Created by 홍정민 on 2022/04/30.
//

import UIKit
import SnapKit
import SwiftyJSON
import Then
import RxCocoa
import RxSwift
import Moya

protocol CancelDelegate {
    func cancelUpdate(isCanceled: Bool)
}


class JoinCancelVC: BaseViewController {
    private let makeProvider = MoyaProvider<MakeServices>()

    var delegate: CancelDelegate?
    var id:Int!
    var isCanceled: Bool = false
    
    let stackView1 = UIStackView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .fillEqually
    }
    
    var popupView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 32
    }
    
    var sadImage = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "icon_sad")
        $0.contentMode = .scaleAspectFit
    }
    
    var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "참여를 취소하시겠어요?"
        $0.font = .minsans(size: 20, family: .Bold)
        $0.textColor = .grayScale100
    }
    
    var subTitleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 16, family: .Medium)
        $0.textColor = .grayScale300
        $0.text = "취소하더라도 다시 신청할 수 있어요."
    }
    
    var resetBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.setTitle("아니요", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 20
    }
    
    var cancelBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .yellow200
        $0.setTitle("참여취소", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 20
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
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY)
            $0.height.equalTo(316)
        }
        
        sadImage.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalTo(popupView.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(sadImage.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        stackView1.snp.makeConstraints{
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(32)
            $0.leading.equalTo(popupView.snp.leading).offset(24)
            $0.trailing.equalTo(popupView.snp.trailing).offset(-24)
            $0.height.equalTo(56)
        }
        
        
        
    }
    
    private func bind(){
        resetBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.isCanceled = false
                self?.closePopup()
            })
            .disposed(by: disposeBag)
        
        //참여 취소 서버통신
        cancelBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.deleteParticipant()
            })
            .disposed(by: disposeBag)
    }
    
    @objc func deleteParticipant() {
        makeProvider.rx.request(.deleteParticipant(id: self.id))
            .asObservable()
            .subscribe(onNext: { [weak self] response in
                let status = JSON(response.data)["status"]
                if status == 200 {
                    self?.isCanceled = true
                    self?.closePopup() //팝업을 닫으면서 delegate로 참여화면에 토스트 출력함
                }else{
                    print("\(status)")
                }
            }, onError: { [weak self] _ in
                print("error occured")
            }, onCompleted: {
                
            }).disposed(by: disposeBag)
    }
    
    private func closePopup(){
        self.delegate?.cancelUpdate(isCanceled: isCanceled)
        self.dismiss(animated:true)
    }
    
    
}

