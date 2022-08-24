//
//  JoinFinishVC.swift
//  Join
//
//  Created by 홍정민 on 2022/05/05.
//
import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import Moya
import SwiftyJSON


protocol FinishDelegate {
    func finishUpdate()
}


class JoinFinishVC: BaseViewController {
    private let makeProvider = MoyaProvider<MakeServices>()
    var delegate: FinishDelegate?
    var isFinished: Bool = false
    var id: Int = 0
    
    let stackView1 = UIStackView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 7
        $0.distribution = .fillEqually
    }
    
    var popupView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 30
    }
    
    var iconImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "finish1")
        $0.contentMode = .scaleAspectFit
    }
    
    var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "번개를 마감하시겠어요?"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 20, family: .Bold)
    }
    
    var subTitleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "마감 후에는 참여자를 모을 수 없어요."
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 16, family: .Medium)
    }
    
    var resetBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.setTitle("아니요", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 20
    }
    
    var finishBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .yellow200
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.setTitle("마감하기", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
    }
    
}



extension JoinFinishVC {
    private func setLayout() {
        self.view.backgroundColor = UIColor(red: 17/255, green: 23/255, blue: 35/255, alpha: 0.6)
        
        view.add(popupView)
        
        stackView1.addArrangedSubview(resetBtn)
        stackView1.addArrangedSubview(finishBtn)
        
        popupView.adds([
            iconImageView,
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
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(24)
            $0.centerX.equalTo(popupView.snp.centerX)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.centerX.equalTo(titleLabel.snp.centerX)
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
                self?.closePopup()
            })
            .disposed(by: disposeBag)
        
        finishBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.close()
            })
            .disposed(by: disposeBag)
    }
    
    private func closePopup(){
        self.dismiss(animated:true, completion: {
            if(self.isFinished){
                self.delegate?.finishUpdate()
            }
        })
    }
    
    func close() {
        makeProvider.rx.request(.close(id: self.id))
            .asObservable()
            .subscribe(onNext: { [weak self] response in
                let status = JSON(response.data)["status"]
                if status == 200 {
                }else{
                    print("id:\(self?.id) 마감 success")
                    self?.isFinished = true
                    self?.closePopup()
                }
            }, onError: { [weak self] _ in
                print("error occured")
            }, onCompleted: {
                
            }).disposed(by: disposeBag)
    }
    
    
}

