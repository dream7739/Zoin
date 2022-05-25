//
//  JoinVC.swift
//  Join
//
//  Created by 이윤진 on 2022/04/20.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift


protocol FinishMainDelegate {
    func finishMainUpdate()
}


class JoinVC: BaseViewController {
    
    var atndFlag = false //참여여부 플래그
    var joinType = 1 //임시 -> 1: 친구 번개 / 2: 내 번개
    var viewTranslation:CGPoint = CGPoint(x: 0, y: 0)
    var delegate: FinishMainDelegate?
    var popupViewTopConstraint: Constraint? = nil
    
    var popupView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 40
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    let btnStackView = UIStackView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 7
        $0.distribution = .fillEqually
    }
    
    var indicatorLabel = UILabel().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .lightGray
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    
    var profileImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "profile")
    }
    
    var moreImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "icon_more")
    }
    
    var timeImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "icon_time")
    }
    
    var placeImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "icon_place")
    }
    
    var attendImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "icon_attend")
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
    
    var attendConfirmBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .lightGray
        $0.setTitle("참여자 확인하기", for: .normal)
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



extension JoinVC: CancelDelegate, FinishDelegate {
    func cancelUpdate(isCanceled: Bool) {
        if(isCanceled){
            self.showToast(message: "번개 참여가 취소되었어요.")
        }
    }
    
    func finishUpdate() {
      dismiss(animated: true, completion: {
                self.delegate?.finishMainUpdate() //메인에서 팝업 노출
      })
    }
    
    private func setLayout() {
        self.view.backgroundColor = UIColor(red: 17/255, green: 23/255, blue: 35/255, alpha: 0.6)
        view.add(popupView)
        
        btnStackView.addArrangedSubview(attendConfirmBtn)
        btnStackView.addArrangedSubview(finishBtn)
        
        popupView.adds([
            indicatorLabel,
            profileImg,
            moreImg,
            timeImg,
            placeImg,
            attendImg,
            nameLabel,
            idLabel,
            countLabel,
            titleLabel,
            dateLabel,
            placeLabel,
            lineImage,
            contentLabel,
            attendLabel,
            joinBtn,
            btnStackView
        ])
        
        
        if(joinType == 1){
            moreImg.isHidden = true
            btnStackView.isHidden = true
        }else{
            joinBtn.isHidden = true
        }
        
        
        //dismiss gesture 추가
        viewTranslation = CGPoint(x: popupView.frame.minX, y: popupView.frame.minY)
       
        popupView.addGestureRecognizer(UIPanGestureRecognizer(target:self, action: #selector(handleDismiss)))
        
        popupView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            popupViewTopConstraint = $0.top.equalToSuperview().offset(131).constraint
            
        }
        
        indicatorLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(48)
            $0.height.equalTo(6)

        }
        
        profileImg.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(24)
        }
        
        moreImg.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.top.equalTo(profileImg)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        timeImg.snp.makeConstraints {
            $0.width.height.equalTo(22)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        placeImg.snp.makeConstraints {
            $0.width.height.equalTo(22)
            $0.leading.equalTo(timeImg.snp.leading)
            $0.top.equalTo(timeImg.snp.bottom).offset(4)
        }
        
        attendImg.snp.makeConstraints {
            $0.width.height.equalTo(22)
            $0.leading.equalTo(placeImg.snp.leading)
            $0.top.equalTo(placeImg.snp.bottom).offset(4)
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
            $0.top.equalTo(profileImg.snp.bottom).offset(32)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(timeImg.snp.trailing).offset(4)
            $0.centerY.equalTo(timeImg.snp.centerY)
        }
        
        placeLabel.snp.makeConstraints {
            $0.leading.equalTo(placeImg.snp.trailing).offset(4)
            $0.centerY.equalTo(placeImg.snp.centerY)
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(attendImg.snp.trailing).offset(4)
            $0.centerY.equalTo(attendImg.snp.centerY)
        }
        
        lineImage.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(attendImg.snp.bottom).offset(16)
            $0.leading.equalTo(attendImg.snp.leading)
            $0.trailing.equalToSuperview().offset(-24)
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
        
        btnStackView.snp.makeConstraints{
            $0.bottom.equalToSuperview().offset(-46)
            $0.leading.equalTo(contentLabel.snp.leading)
            $0.trailing.equalTo(contentLabel.snp.trailing)
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
        
        
        finishBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.clickFinishBtn()
            })
            .disposed(by: disposeBag)
        
        
        attendConfirmBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.clickAttendConfirmBtn()
            })
            .disposed(by: disposeBag)
        
    }
    
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer){
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: self.popupView)
            if(self.view.frame.minY < self.viewTranslation.y){
                let newPosition = 131 + self.viewTranslation.y
                self.popupView.snp.updateConstraints{
                    self.popupViewTopConstraint =  $0.top.equalToSuperview().offset(newPosition).constraint
                }
            }
            
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.popupView.snp.updateConstraints{
                        self.popupViewTopConstraint =  $0.top.equalToSuperview().offset(131).constraint
                    }
                })
            } else {
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    private func clickCancelBtn(){
        let joinCancelVC = JoinCancelVC()
        joinCancelVC.delegate = self
        joinCancelVC.modalPresentationStyle = .overFullScreen
        self.present(joinCancelVC, animated: true)
    }
    
    private func clickFinishBtn(){
        let joinFinishVC = JoinFinishVC()
        joinFinishVC.delegate = self
        joinFinishVC.modalPresentationStyle = .overFullScreen
        self.present(joinFinishVC, animated: true)
    }
    
    private func clickAttendConfirmBtn(){
        let joinMemberConfirmVC = JoinMemberConfirmVC()
        joinMemberConfirmVC.modalPresentationStyle = .overFullScreen
        self.present(joinMemberConfirmVC, animated: true)
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

