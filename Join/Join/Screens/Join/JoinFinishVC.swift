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


protocol FinishDelegate {
    func finishUpdate()
}


class JoinFinishVC: BaseViewController {
    
    var delegate: FinishDelegate?
    var isFinished: Bool = false
    
    let stackView1 = UIStackView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 7
        $0.distribution = .fillEqually
    }
    
    var popupView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
    }
    
    var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "번개를 마감하시겠어요?"
        $0.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    var subTitleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "번개에 대해 더이상 수정할 수 없어요."
    }
    
    var resetBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .lightGray
        $0.setTitle("아니요", for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 16
    }
    
    var finishBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .darkGray
        $0.setTitle("마감하기", for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 16
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
            titleLabel,
            subTitleLabel,
            stackView1

        ])
        
        popupView.snp.makeConstraints{
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY)
            $0.height.equalTo(212)
        }
        
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(popupView.snp.top).offset(40)
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
                self?.isFinished = true
                self?.closePopup()
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
    
    
}

