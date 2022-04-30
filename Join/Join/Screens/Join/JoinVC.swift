//
//  JoinVC.swift
//  Join
//
//  Created by 이윤진 on 2022/04/20.
//

import UIKit

class JoinVC: BaseViewController {
    
    var atndFlag = false //참여여부 플래그
    var joinType = 1 //내 번개인지? 친구 번개인지?(서버 데이터 타입에 맞추기)
    
    var popupView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 40
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    
    var profileImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "profile")
    }
    
    var nameLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "장혜진"
        $0.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    var idLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "@b2_cka_"
    }
    
    var countLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "2/3"
    }
    
    var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "인생샷 찍으러 가자!"
        $0.font = UIFont.boldSystemFont(ofSize: 30)
    }
    
    var dateLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "오늘 오후 04:00"
    }
    
    var placeLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "여의나루역 2번 출구 앞"
    }
    
    var lineImage = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .lightGray
    }
    
    var contentLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "이따 학원끝나고 시간나는김에 카페 한번 들리려하는데 나 놀아줄사람..?ㅠㅠ"
        $0.numberOfLines = 0
    }
    
    var attendLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "참여중"
        $0.backgroundColor  = .lightGray
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
        $0.font = UIFont.systemFont(ofSize:13)
        $0.textAlignment = .center
        $0.isHidden = true //초기에 보이지 않다가 참여 액션이 있을 때 보임
    }
    
    var joinBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .darkGray
        $0.setTitle("참여하기", for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
    }
    
}



extension JoinVC: CancelDelegate {
    func cancelUpdate(isCanceled: Bool) {
        if(isCanceled){
            self.showToast(message: "번개 참여가 취소되었어요.")
        }
    }
    
    private func setLayout() {
        self.view.backgroundColor = UIColor(red: 17/255, green: 23/255, blue: 35/255, alpha: 0.6)
            
        view.add(popupView)
        
        popupView.adds([
            profileImg,
            nameLabel,
            idLabel,
            countLabel,
            titleLabel,
            dateLabel,
            placeLabel,
            lineImage,
            contentLabel,
            attendLabel,
            joinBtn
        ])
        
        popupView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(681)
        }
        
        profileImg.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImg)
            $0.leading.equalTo(profileImg.snp.trailing).offset(10)
        }
        
        idLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImg.snp.leading)
            $0.top.equalTo(profileImg.snp.bottom).offset(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImg.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
        
        placeLabel.snp.makeConstraints {
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.top.equalTo(dateLabel.snp.bottom).offset(5)
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(placeLabel.snp.leading)
            $0.top.equalTo(placeLabel.snp.bottom).offset(5)
        }
        
        lineImage.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(countLabel.snp.bottom).offset(5)
            $0.leading.equalTo(profileImg.snp.leading)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(lineImage.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(lineImage)
        }
        
        attendLabel.snp.makeConstraints {
            $0.leading.equalTo(countLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(countLabel)
            $0.width.equalTo(40)
        }
        
        joinBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-45)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(56)
        }
    }
    
    private func bind(){
        joinBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                if(!(self!.atndFlag)){
                    //토스트 출력 & 참여중 라벨 표시 & 참여취소로 버튼 변경
                    self?.joinBtn.setTitle("참여취소", for: .normal)
                    self?.joinBtn.backgroundColor = .lightGray
                    self?.attendLabel.isHidden = false
                    self?.atndFlag = true
                    self?.showToast(message: "친구 번개에 참여했어요!")
                }else{
                    self?.clickCancelBtn()
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func clickCancelBtn(){
        let joinCancelVC = JoinCancelVC()
        joinCancelVC.delegate = self
        joinCancelVC.modalPresentationStyle = .overFullScreen
        self.present(joinCancelVC, animated: true)
    }
    
    
    private func showToast(message : String){
        let toastLabel = UILabel().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .black
            $0.textColor = .white
            $0.textAlignment = .center
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 16
            $0.text = message
        }
        popupView.addSubview(toastLabel)
        
        toastLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(56)
            $0.bottom.equalTo(joinBtn.snp.top).offset(-10)
        }
        
        UIView.animate(withDuration: 1.5, delay: 0.01, animations: {
           toastLabel.alpha = 0.0
        }, completion: { _ in
           toastLabel.removeFromSuperview()
        })

    }
    
    
    
    
}

